#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 5000   ; 사라진 후 0.5초 뒤 재출현 (총 5초 애니메이션 + 0.5초 대기)
global MoveResetInterval := 1000  ; 💡 마우스 움직인 후 다시 그려질 때까지의 대기 시간 (1초)
global CircleRadius := 600       
global InnerRadius := 595        
global CircleColor := "FFFF00"
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
    global IsActive, HighlightInterval

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
}
; ==========================================
; 원 생성
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, InnerRadius, CircleColor
    global CurrentAlpha, FadeMode, FadeInDuration, FadingSteps
    global BaseMouseX, BaseMouseY
    global HighlightInterval

    ; 💡 새로운 원을 그리기 전에 모든 타이머를 확실히 꺼서 겹침 방지
    StopAllTimers()
    DestroyHighlight()

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    BaseMouseX := mouseX
    BaseMouseY := mouseY

    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HighlightGui.BackColor := CircleColor

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
    
    ; 원이 성공적으로 그려진 '이 시점'부터 감지 및 반복 타이머를 가동합니다.
    SetTimer(CheckMouseMovement, 10)

}

; ==========================================
; 실시간 마우스 이동 감지
; ==========================================
CheckMouseMovement() {
    global MoveResetInterval, BaseMouseX, BaseMouseY
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&cX, &cY)
    
    if (cX != BaseMouseX || cY != BaseMouseY) {
        ; 💡 마우스 움직임이 감지되면 즉시 모든 타이머를 중단하고 원을 지웁니다.
        StopAllTimers()
        DestroyHighlight()
        
        ; 정확히 MoveResetInterval(1초) 후에 ShowHighlight가 '단 한 번만(-)' 켜지도록 예약합니다.
        ; 이렇게 해야 1초 뒤에 새로 그려지면서 내부에서 5.5초 타이머가 깨끗하게 시작됩니다.
        SetTimer(ShowHighlight, -MoveResetInterval)
    }
}

; ==========================================
; 페이드 애니메이션
; ==========================================
FadeAnimate() {
    global HighlightGui, TargetAlpha, CurrentAlpha, FadeMode, FadingSteps
    global CircleDuration, FadeOutDuration

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

        DestroyHighlight()

        ; 0.5초 후 다시 생성
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
; 시작하자마자 자동 ON
; ==========================================
SetTimer(StartupHighlight, -10)

StartupHighlight() {
    global IsActive
    if (!IsActive)
        ToggleHighlight()
}