#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 6000
global CircleRadius := 60
global CircleColor := "FFFF00"
global TargetAlpha := 100

global FadeInDuration := 1000
global CircleDuration := 700
global FadeOutDuration := 500
global FadingSteps := 10

global IsActive := false
global HighlightGui := ""
global CurrentAlpha := 0
global FadeMode := 0

; ==========================================
; F11 핫키 (짧게/길게)
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
        SetTimer(ShowHighlight, HighlightInterval)
    } else {
        ToolTip("마우스 하이라이트: 꺼짐")
        SetTimer(() => ToolTip(), -1000)

        SetTimer(ShowHighlight, 0)
        SetTimer(FadeAnimate, 0)
        DestroyHighlight()
    }
}

; ==========================================
; 원 생성
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, CircleColor
    global CurrentAlpha, FadeMode, FadeInDuration, FadingSteps

    DestroyHighlight()
    SetTimer(FadeAnimate, 0)

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)

    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HighlightGui.BackColor := CircleColor

    diameter := CircleRadius * 2
    HighlightGui.Show("X" (mouseX - CircleRadius) " Y" (mouseY - CircleRadius)
        " W" diameter " H" diameter " NoActivate")

    CurrentAlpha := 0
    WinSetTransparent(CurrentAlpha, HighlightGui.Hwnd)
    WinSetRegion("0-0 W" diameter " H" diameter " E", HighlightGui.Hwnd)

    FadeMode := 1
    stepTime := FadeInDuration / FadingSteps
    SetTimer(FadeAnimate, stepTime)
}

; ==========================================
; 페이드 애니메이션 + 마우스 이동 감지
; ==========================================
FadeAnimate() {
    global HighlightGui, TargetAlpha, CurrentAlpha, FadeMode, FadingSteps
    global CircleDuration, FadeOutDuration, HighlightInterval

    static currentStep := 0
    static lastX := 0, lastY := 0

    if !(HighlightGui is Gui) {
        SetTimer(FadeAnimate, 0)
        currentStep := 0
        return
    }

    CoordMode("Mouse", "Screen")
    MouseGetPos(&currentX, &currentY)

    if (currentStep == 0) {
        lastX := currentX
        lastY := currentY
    }
    else if (currentX != lastX || currentY != lastY) {
        SetTimer(FadeAnimate, 0)
        currentStep := 0
        DestroyHighlight()
        SetTimer(ShowHighlight, HighlightInterval)
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
            DestroyHighlight()
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
; 🚀 시작하자마자 자동 ON
; ==========================================
SetTimer(StartupHighlight, -10)

StartupHighlight() {
    global IsActive
    if (!IsActive)
        ToggleHighlight()
}