#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 설정 변수
; ==========================================
global HighlightInterval := 6000  ; 하이라이트 반복 주기 (6초)
global CircleRadius := 60         ; 원의 반지름
global CircleColor := "FFFF00"    ; 하이라이트 색상 (노란색)
global TargetAlpha := 100         ; 목표 투명도 (최대 밝기)

; 페이드 인/아웃 설정
global FadeInDuration := 1000     ; 페이드인 시간 (1초)
global CircleDuration := 700      ; 최대 밝기 유지 시간 (0.7초)
global FadeOutDuration := 500     ; 페이드아웃 시간 (0.5초)
global FadingSteps := 10          ; 애니메이션 단계 수

; 상태 관리 변수
global IsActive := false
global HighlightGui := ""
global CurrentAlpha := 0
global FadeMode := 0              ; 1: 페이드인, 2: 페이드아웃

; ==========================================
; F11 핫키 설정 (짧게/길게 분리)
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
; 기능 온/오프 토글 함수
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
; 하이라이트 생성 및 애니메이션 시작
; ==========================================
ShowHighlight() {
    global HighlightGui, CircleRadius, CircleColor, CurrentAlpha, FadeMode, FadeInDuration, FadingSteps

    DestroyHighlight()
    SetTimer(FadeAnimate, 0) ; 기존 애니메이션 타이머 초기화
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    HighlightGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    HighlightGui.BackColor := CircleColor
    
    diameter := CircleRadius * 2
    HighlightGui.Show("X" (mouseX - CircleRadius) " Y" (mouseY - CircleRadius) " W" diameter " H" diameter " NoActivate")
    
    ; 투명도 0에서 시작 후 리전 적용
    CurrentAlpha := 0
    WinSetTransparent(CurrentAlpha, HighlightGui.Hwnd)
    WinSetRegion("0-0 W" diameter " H" diameter " E", HighlightGui.Hwnd)

    ; 페이드인 타이머 시작
    FadeMode := 1 
    stepTime := FadeInDuration / FadingSteps
    SetTimer(FadeAnimate, stepTime)
}

; ==========================================
; 페이드 인/아웃 통합 애니메이션 함수 (마우스 감지 추가)
; ==========================================
FadeAnimate() {
    global HighlightGui, TargetAlpha, CurrentAlpha, FadeMode, FadingSteps
    global CircleDuration, FadeOutDuration, HighlightInterval
    static currentStep := 0
    static lastX := 0, lastY := 0  ; 이전 마우스 위치 저장용 변수

    if !(HighlightGui is Gui) {
        SetTimer(FadeAnimate, 0)
        currentStep := 0
        return
    }

    ; ------------------------------------------
    ; 마우스 움직임 감지 로직
    ; ------------------------------------------
    CoordMode("Mouse", "Screen")
    MouseGetPos(&currentX, &currentY)
    
    ; 애니메이션 시작 첫 단계(step 1)일 때는 현재 위치를 기준점으로 기록
    if (currentStep == 0) {
        lastX := currentX
        lastY := currentY
    }
    ; 애니메이션 도중 마우스가 움직였다면?
    else if (currentX != lastX || currentY != lastY) {
        SetTimer(FadeAnimate, 0)  ; 애니메이션 중지
        currentStep := 0          ; 단계 초기화
        DestroyHighlight()        ; 원 삭제
        
        ; 중요: 메인 반복 타이머(쿨타임)를 처음부터 다시 시작
        SetTimer(ShowHighlight, HighlightInterval) 
        return
    }

    currentStep++

    if (FadeMode == 1) { ; 페이드인 진행
        CurrentAlpha := TargetAlpha * (currentStep / FadingSteps)
        
        if (currentStep >= FadingSteps) {
            WinSetTransparent(Integer(TargetAlpha), HighlightGui.Hwnd)
            SetTimer(FadeAnimate, 0) ; 페이드인 타이머 정지
            currentStep := 0
            ; 유지 시간 후에 페이드아웃 전환 설정
            SetTimer(SwitchToFadeOut, -CircleDuration)
            return
        }
    } 
    else if (FadeMode == 2) { ; 페이드아웃 진행
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