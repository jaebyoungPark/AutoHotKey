#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 7000
global MoveResetInterval := 2000  ; 💡 마우스 움직인 후 다시 그려질 때까지의 대기 시간 (2초)
global CircleRadius := 600       ; 반지름 (지름 1200)
global InnerRadius := 595        ; 도넛 내부 빈 공간의 반지름 (두께 5px)
global CircleColor := "FFFF00"
global TargetAlpha := 70

global FadeInDuration := 1000
global CircleDuration := 3500
global FadeOutDuration := 500
global FadingSteps := 10

global IsActive := false
global HighlightGui := ""
global CurrentAlpha := 0
global FadeMode := 0

; 마우스 실시간 감지를 위한 변수
global BaseMouseX := 0
global BaseMouseY := 0

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
        SetTimer(CheckMouseMovement, 0) ; 감지 타이머 끄기
        DestroyHighlight()
    }
}

; ==========================================
; 원 생성 (Windows API를 이용한 도넛 모양 구현)
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, InnerRadius, CircleColor
    global CurrentAlpha, FadeMode, FadeInDuration, FadingSteps
    global BaseMouseX, BaseMouseY
    global HighlightInterval ; 💡 자동 반복 타이머를 정상 작동시키기 위해 추가

    DestroyHighlight()
    SetTimer(FadeAnimate, 0)
    SetTimer(CheckMouseMovement, 0) ; 기존 감지 타이머 초기화

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    ; 원이 생성된 시점의 기준 마우스 좌표 저장
    BaseMouseX := mouseX
    BaseMouseY := mouseY

    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HighlightGui.BackColor := CircleColor

    diameter := CircleRadius * 2
    HighlightGui.Show("X" (mouseX - CircleRadius) " Y" (mouseY - CircleRadius)
        " W" diameter " H" diameter " NoActivate")

    CurrentAlpha := 0
    WinSetTransparent(CurrentAlpha, HighlightGui.Hwnd)
    
    ; Windows API를 이용한 도넛 영역 생성
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
    
    ; 💡 마우스 움직임 감지 타이머 작동
    SetTimer(CheckMouseMovement, 10)

    ; 💡 중요: 마우스를 움직여서 강제로 재시작된 경우, 원래의 8초 주기 자동 타이머를 다시 정상화합니다.
    SetTimer(ShowHighlight, HighlightInterval)
}

; ==========================================
; 실시간 마우스 이동 감지 루프
; ==========================================
CheckMouseMovement() {
    global MoveResetInterval, BaseMouseX, BaseMouseY ; 💡 MoveResetInterval 참조
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&cX, &cY)
    
    ; 기준 좌표에서 마우스가 벗어났다면 즉시 원을 파괴하고 2초 뒤에 재생성하도록 설정
    if (cX != BaseMouseX || cY != BaseMouseY) {
        SetTimer(CheckMouseMovement, 0)
        SetTimer(FadeAnimate, 0)
        DestroyHighlight()
        
        ; 💡 원래의 8초 타이머를 끄고, 마우스 이동 전용 변수(2초)를 사용하여 타이머를 작동시킵니다.
        SetTimer(ShowHighlight, MoveResetInterval)
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
            SetTimer(CheckMouseMovement, 0) ; 페이드 아웃 완료 시 감지 종료
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