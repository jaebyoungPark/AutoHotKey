#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"

; ==============================
; 🔧 전역 설정값
; ==============================
global MoveAmount := 8      ; 한 Tick당 이동량 (픽셀)
global MoveInterval := 8   ; 이동 반복 간격 (ms)

; 방향 플래그
global MoveLeft := false
global MoveRight := false
global MoveUp := false
global MoveDown := false

; ==============================
; ▶ 타이머 함수
; ==============================
MoveMouse()
{
    global MoveLeft, MoveRight, MoveUp, MoveDown, MoveAmount
    MouseGetPos &x, &y

    if MoveLeft
        x -= MoveAmount
    if MoveRight
        x += MoveAmount
    if MoveUp
        y -= MoveAmount
    if MoveDown
        y += MoveAmount

    ; 아무 방향도 없으면 종료
    if !(MoveLeft || MoveRight || MoveUp || MoveDown)
        return

    MouseMove x, y, 0  ; 마지막 0 → 1~10으로 바꾸면 더 부드럽게
}

; ==============================
; ▶ RShift + Z/X/C/V 단축키 (눌렀을 때)
; ==============================
RShift & z::
{
    global MoveLeft
    MoveLeft := true
    SetTimer MoveMouse, MoveInterval
    return
}

RShift & x::
{
    global MoveRight
    MoveRight := true
    SetTimer MoveMouse, MoveInterval
    return
}

RShift & c::
{
    global MoveUp
    MoveUp := true
    SetTimer MoveMouse, MoveInterval
    return
}

RShift & v::
{
    global MoveDown
    MoveDown := true
    SetTimer MoveMouse, MoveInterval
    return
}

; ==============================
; ▶ RShift + Z/X/C/V 단축키 (뗐을 때)
; ==============================
RShift & z up::
{
    global MoveLeft
    MoveLeft := false
    CheckStop()
    return
}

RShift & x up::
{
    global MoveRight
    MoveRight := false
    CheckStop()
    return
}

RShift & c up::
{
    global MoveUp
    MoveUp := false
    CheckStop()
    return
}

RShift & v up::
{
    global MoveDown
    MoveDown := false
    CheckStop()
    return
}

; ==============================
; ▶ 이동 멈춤 체크
; ==============================
CheckStop()
{
    global MoveLeft, MoveRight, MoveUp, MoveDown
    if !(MoveLeft || MoveRight || MoveUp || MoveDown)
        SetTimer MoveMouse, 0  ; 모든 방향이 false면 타이머 중지
}