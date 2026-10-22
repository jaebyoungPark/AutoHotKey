#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global MoveResetInterval := 1000  ; 마우스 움직인 후 다시 그려질 때까지의 대기 시간 (1초)
global LineWidth := 50         ; 모니터 양쪽 세로선의 두께 (픽셀)
global TargetAlpha := 70          ; 투명도 (0 ~ 255)

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
global BaseMonitorIndex := 1

; 💡 알록달록 색상 관련 변수
global ColorHue := 0              ; 현재 색상 값 (0 ~ 360)
global ColorSpeed := 2            ; 색상이 변하는 속도

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
        ToolTip("모니터 양쪽 세로선 하이라이트: 켜짐")
        SetTimer(() => ToolTip(), -1000)
        ShowHighlight()
    } else {
        ToolTip("모니터 양쪽 세로선 하이라이트: 꺼짐")
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
    SetTimer(ChangeColorAnimate, 0)
}

; ==========================================
; 세로선 생성 (모니터 좌우측)
; ==========================================
ShowHighlight() {
    global HighlightGui, LineWidth
    global CurrentAlpha, FadeMode, FadeInDuration, FadingSteps
    global BaseMouseX, BaseMouseY, BaseMonitorIndex

    StopAllTimers()
    DestroyHighlight()

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    mLeft := 0, mTop := 0, mRight := A_ScreenWidth, mBottom := A_ScreenHeight
    currentMonitor := 1
    
    monCount := MonitorGetCount()
    Loop monCount {
        if MonitorGetWorkArea(A_Index, &l, &t, &r, &b) {
            if (mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) {
                currentMonitor := A_Index
                mLeft := l, mTop := t, mRight := r, mBottom := b
                break
            }
        }
    }

    BaseMouseX := mouseX
    BaseMouseY := mouseY
    BaseMonitorIndex := currentMonitor

    monitorWidth := mRight - mLeft
    ; 💡 작업바와의 미세한 충돌 및 깜빡임 방지를 위해 높이를 2픽셀 줄임
    monitorHeight := (b - mTop) - 2

    ; -DPIScale을 추가하여 모니터 배율에 따른 크기/위치 왜곡 방지
    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 -DPIScale")
    
    initialColor := HSVtoRGB(ColorHue, 100, 100)
    HighlightGui.BackColor := initialColor

    ; 작업바를 제외하고 약간 여유를 둔 영역으로 GUI 생성
    HighlightGui.Show("X" mLeft " Y" mTop " W" monitorWidth " H" monitorHeight " NoActivate")

    CurrentAlpha := 0
    WinSetTransparent(CurrentAlpha, HighlightGui.Hwnd)
    
    ; 왼쪽 세로선 영역 생성
    hRgnLeft := DllCall("gdi32\CreateRectRgn", "Int", 0, "Int", 0, "Int", LineWidth, "Int", monitorHeight, "Ptr")
    ; 오른쪽 세로선 영역 생성
    hRgnRight := DllCall("gdi32\CreateRectRgn", "Int", monitorWidth - LineWidth, "Int", 0, "Int", monitorWidth, "Int", monitorHeight, "Ptr")
    
    ; 두 영역을 합침 (RGN_OR = 2)
    DllCall("gdi32\CombineRgn", "Ptr", hRgnLeft, "Ptr", hRgnLeft, "Ptr", hRgnRight, "Int", 2)
    DllCall("user32\SetWindowRgn", "Ptr", HighlightGui.Hwnd, "Ptr", hRgnLeft, "Int", 1)
    DllCall("gdi32\DeleteObject", "Ptr", hRgnRight)

    FadeMode := 1
    stepTime := FadeInDuration / FadingSteps
    SetTimer(FadeAnimate, stepTime)
    
    SetTimer(CheckMouseMovement, 10)
    SetTimer(ChangeColorAnimate, 30)
}

; ==========================================
; 실시간 마우스 이동 및 모니터 변경 감지
; ==========================================
CheckMouseMovement() {
    global MoveResetInterval, BaseMouseX, BaseMouseY, BaseMonitorIndex
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&cX, &cY)
    
    targetMon := 1
    monCount := MonitorGetCount()
    Loop monCount {
        if MonitorGetWorkArea(A_Index, &l, &t, &r, &b) {
            if (cX >= l && cX <= r && cY >= t && cY <= b) {
                targetMon := A_Index
                break
            }
        }
    }
    
    if (targetMon != BaseMonitorIndex || cX != BaseMouseX || cY != BaseMouseY) {
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
            SetTimer(ChangeColorAnimate, 0)

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
; 알록달록 색상 변경 함수
; ==========================================
ChangeColorAnimate() {
    global HighlightGui, ColorHue, ColorSpeed
    if !(HighlightGui is Gui)
        return

    ColorHue := Mod(ColorHue + ColorSpeed, 360)
    rgbColor := HSVtoRGB(ColorHue, 100, 100)
    HighlightGui.BackColor := rgbColor
}

; HSV를 HEX 코드로 변환하는 헬퍼 함수
HSVtoRGB(h, s, v) {
    s /= 100, v /= 100
    if (s == 0) {
        return Format("{:02X}{:02X}{:02X}", Integer(v*255), Integer(v*255), Integer(v*255))
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