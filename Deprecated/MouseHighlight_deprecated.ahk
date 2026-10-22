
#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 5000   ; 사라진 후 0.5초 뒤 재출현
global MoveResetInterval := 1000  ; 마우스 움직인 후 다시 그려질 때까지의 대기 시간 (1초)
global CircleRadius := 500       
global InnerRadius := 490        
global TargetAlpha := 70

global FadeInDuration := 300
global CircleDuration := 3500
global FadeOutDuration := 500
global FadingSteps := 10

global IsActive := false
global HighlightGui := ""
global CurrentAlpha := 0
global FadeMode := 0

global BaseMouseX := 0
global BaseMouseY := 0

; 💡 알록달록 색상 관련 변수
global ColorHue := 0             ; 현재 색상 값 (0 ~ 360)
global ColorSpeed := 2           ; 색상이 변하는 속도 (숫자가 클수록 빠르게 변함)

; ==========================================
; F11 핫키
; ==========================================
$F11:: {
    if !KeyWait("F11", "T0.5") {
        ToggleHighlight()
        KeyWait("F11")
    } else {
        Send("{F11 Down}")
        Sleep(10)
        Send("{F11 Up}")
    }
}

; ==========================================
; 토글
; ==========================================
ToggleHighlight() {
    global IsActive

    IsActive := !IsActive

    if (IsActive) {
        ToolTip("마우스 하이라이트: 켜짐")
        SetTimer(() => ToolTip(), -1000)
        ShowHighlight()
    } else {
        ToolTip("마우스 하이라이트: 꺼짐")
        SetTimer(() => ToolTip(), -1000)
        StopAllTimers()
        DestroyHighlight()
    }
}

; 모든 타이머를 일괄 중지하는 헬퍼 함수
StopAllTimers() {
    SetTimer(ShowHighlight, 0)
    SetTimer(FadeAnimate, 0)
    SetTimer(CheckMouseMovement, 0)
    SetTimer(SwitchToFadeOut, 0)
    SetTimer(ChangeColorAnimate, 0) ; 💡 색상 타이머도 정지
}

; ==========================================
; 원 생성
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, InnerRadius
    global CurrentAlpha, FadeMode, FadeInDuration, FadingSteps
    global BaseMouseX, BaseMouseY

    StopAllTimers()
    DestroyHighlight()

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    BaseMouseX := mouseX
    BaseMouseY := mouseY

    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    
    ; 초기 색상을 가져와 지정합니다.
    initialColor := HSVtoRGB(ColorHue, 100, 100)
    HighlightGui.BackColor := initialColor

    diameter := CircleRadius * 2
    HighlightGui.Show("X" (mouseX - CircleRadius) " Y" (mouseY - CircleRadius)
        " W" diameter " H" diameter " NoActivate")

    CurrentAlpha := 0
    WinSetTransparent(CurrentAlpha, HighlightGui.Hwnd)
    
    hRgnOuter := DllCall("gdi32\CreateEllipticRgn", "Int", 0, "Int", 0, "Int", diameter, "Int", diameter, "Ptr")
    innerOffset := CircleRadius - InnerRadius
    innerDiameter := innerOffset + (InnerRadius * 2)
    hRgnInner := DllCall("gdi32\CreateEllipticRgn", "Int", innerOffset, "Int", innerOffset, "Int", innerDiameter, "Int", innerDiameter, "Ptr")
    
    DllCall("gdi32\CombineRgn", "Ptr", hRgnOuter, "Ptr", hRgnOuter, "Ptr", hRgnInner, "Int", 3)
    DllCall("user32\SetWindowRgn", "Ptr", HighlightGui.Hwnd, "Ptr", hRgnOuter, "Int", 1)
    DllCall("gdi32\DeleteObject", "Ptr", hRgnInner)

    FadeMode := 1
    stepTime := FadeInDuration / FadingSteps
    SetTimer(FadeAnimate, stepTime)
    
    SetTimer(CheckMouseMovement, 10)
    
    ; 💡 원이 켜져 있는 동안 실시간으로 색상을 바꾸는 타이머 가동 (30ms 주기)
    SetTimer(ChangeColorAnimate, 30)
}

; ==========================================
; 실시간 마우스 이동 감지
; ==========================================
CheckMouseMovement() {
    global MoveResetInterval, BaseMouseX, BaseMouseY
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&cX, &cY)
    
    if (cX != BaseMouseX || cY != BaseMouseY) {
        StopAllTimers()
        DestroyHighlight()
        SetTimer(ShowHighlight, -MoveResetInterval)
    }
}

; ==========================================
; 페이드 애니메이션
; ==========================================
FadeAnimate() {
    global HighlightGui, TargetAlpha, CurrentAlpha, FadeMode, FadingSteps
    global CircleDuration

    static currentStep := 0

    if !(HighlightGui is Gui) {
        SetTimer(FadeAnimate, 0)
        currentStep := 0
        return
    }

    currentStep++

    if (FadeMode == 1) {
        CurrentAlpha := TargetAlpha * (currentStep / FadingSteps)

        if (currentStep >= FadingSteps) {
            WinSetTransparent(Integer(TargetAlpha), HighlightGui.Hwnd)
            SetTimer(FadeAnimate, 0)
            currentStep := 0
            SetTimer(SwitchToFadeOut, -CircleDuration)
            return
        }
    }
    else {
        CurrentAlpha := TargetAlpha * (1 - (currentStep / FadingSteps))

        if (CurrentAlpha <= 0 || currentStep >= FadingSteps) {
            SetTimer(FadeAnimate, 0)
            currentStep := 0
            SetTimer(CheckMouseMovement, 0)
            SetTimer(ChangeColorAnimate, 0) ; 💡 사라질 때 색상 타이머 종료

            DestroyHighlight()
            SetTimer(ShowHighlight, -500)
            return
        }
    }

    WinSetTransparent(Max(1, Integer(CurrentAlpha)), HighlightGui.Hwnd)
}

SwitchToFadeOut() {
    global FadeMode, FadeOutDuration, FadingSteps
    FadeMode := 2
    stepTime := FadeOutDuration / FadingSteps
    SetTimer(FadeAnimate, stepTime)
}

DestroyHighlight() {
    global HighlightGui
    if (HighlightGui is Gui) {
        HighlightGui.Destroy()
        HighlightGui := ""
    }
}

; ==========================================
; 💡 알록달록 색상 변경 함수
; ==========================================
ChangeColorAnimate() {
    global HighlightGui, ColorHue, ColorSpeed
    if !(HighlightGui is Gui)
        return

    ; 색상(Hue) 값을 계속 증가시켜 무지개색 효과 유도
    ColorHue := Mod(ColorHue + ColorSpeed, 360)
    rgbColor := HSVtoRGB(ColorHue, 100, 100)
    
    ; GUI의 배경색 실시간 변경
    HighlightGui.BackColor := rgbColor
}

; 💡 HSV(색상, 채도, 명도)를 HEX(RGB) 코드로 변환해주는 헬퍼 함수
HSVtoRGB(h, s, v) {
    s /= 100, v /= 100
    if (s == 0) {
        hex := Format("{:02X}{:02X}{:02X}", Integer(v*255), Integer(v*255), Integer(v*255))
        return hex
    }
    
    h /= 60
    i := Floor(h)
    f := h - i
    p := v * (1 - s)
    q := v * (1 - s * f)
    t := v * (1 - s * (1 - f))
    
    if (i == 0) {
        r := v, g := t, b := p
    } else if (i == 1) {
        r := q, g := v, b := p
    } else if (i == 2) {
        r := p, g := v, b := t
    } else if (i == 3) {
        r := p, g := q, b := v
    } else if (i == 4) {
        r := t, g := p, b := v
    } else {
        r := v, g := p, b := q
    }
    
    return Format("{:02X}{:02X}{:02X}", Integer(r*255), Integer(g*255), Integer(b*255))
}

; ==========================================
; 시작하자마자 자동 ON
; ==========================================
SetTimer(StartupHighlight, -10)

StartupHighlight() {
    global IsActive
    if (!IsActive)
        ToggleHighlight()
}