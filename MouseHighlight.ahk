#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 4000
global CircleRadius := 150        ; 💡 반지름을 60에서 100으로 확대 (지름 200)
global InnerRadius := 130          ; 💡 도넛 내부 빈 공간의 반지름 (두께 = 100 - 70 = 30px)
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
; ==========================================
; 원 생성 (Windows API를 이용한 도넛 모양 구현)
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, InnerRadius, CircleColor
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
    
    ; 💡 [v2 완벽 대응] Windows API를 이용한 도넛 영역 생성
    ; 1. 바깥쪽 원 영역 생성 (0, 0 부터 지름 크기만큼)
    hRgnOuter := DllCall("gdi32\CreateEllipticRgn", "Int", 0, "Int", 0, "Int", diameter, "Int", diameter, "Ptr")
    
    ; 2. 안쪽 원 영역 생성
    innerOffset := CircleRadius - InnerRadius
    innerDiameter := innerOffset + (InnerRadius * 2)
    hRgnInner := DllCall("gdi32\CreateEllipticRgn", "Int", innerOffset, "Int", innerOffset, "Int", innerDiameter, "Int", innerDiameter, "Ptr")
    
    ; 3. 바깥 원에서 안쪽 원을 빼서(XOR = 3) 도넛 모양 만들기
    ; RGN_XOR = 3 (두 영역의 겹치지 않는 부분만 남김)
    DllCall("gdi32\CombineRgn", "Ptr", hRgnOuter, "Ptr", hRgnOuter, "Ptr", hRgnInner, "Int", 3)
    
    ; 4. 만든 도넛 영역을 GUI 윈도우에 적용 (적용 후 OS가 Region 메모리를 관리하므로 직접 삭제 안 해도 됨)
    DllCall("user32\SetWindowRgn", "Ptr", HighlightGui.Hwnd, "Ptr", hRgnOuter, "Int", 1)
    
    ; 5. 사용이 끝난 안쪽 원 영역 메모리 해제
    DllCall("gdi32\DeleteObject", "Ptr", hRgnInner)

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