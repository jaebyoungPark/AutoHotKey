#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Mouse", "Screen"

; ==============================
; 🔧 전역 설정값 (경고 방지)
; ==============================
global MoveStepSlow     := 8     ; ⏳ 초기 느린 이동
global MoveStep         := 40    ; 🚀 가속 후 기본 이동
global MoveStepFine     := 2     ; 🎯 미세 이동

global MoveInterval     := 10
global MoveIntervalFine := 5

global AccelTime        := 300   ; ⏱️ 가속 시작 시간(ms)

; ==============================
; 🔒 Win 키 단독 동작 방지
; ==============================
~LWin::Return
~RWin::Return

; ==============================
; 🖱 Win + 방향키 이동
; ==============================
#Left::  MoveMouse(false)
#Right:: MoveMouse(false)
#Up::    MoveMouse(false)
#Down::  MoveMouse(false)

; ==============================
; 🖱 Win + Ctrl + 방향키 (미세 이동)
; ==============================
#^Left::  MoveMouse(true)
#^Right:: MoveMouse(true)
#^Up::    MoveMouse(true)
#^Down::  MoveMouse(true)

; ==============================
; 🧠 커서 이동 함수 (DPI 안전)
; ==============================
MoveMouse(isFineMode := false)
{
    global MoveStepSlow, MoveStep, MoveStepFine
    global MoveInterval, MoveIntervalFine, AccelTime

    startTime := A_TickCount
    interval  := isFineMode ? MoveIntervalFine : MoveInterval

    ; 가상 화면 (물리 좌표)
    VX := SysGet(76)
    VY := SysGet(77)
    VW := SysGet(78)
    VH := SysGet(79)

    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)

    while (GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        elapsed := A_TickCount - startTime

        ; ⏱️ 가속 처리
        if (isFineMode)
            step := MoveStepFine
        else if (elapsed < AccelTime)
            step := MoveStepSlow
        else
            step := MoveStep

        ; 현재 커서 위치 (물리 좌표)
        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

        ; 이동 계산
        if (isLeft)
            x -= step
        if (isRight)
            x += step
        if (isUp)
            y -= step
        if (isDown)
            y += step

        ; 화면 경계 클램프
        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        ; DPI 안전 이동
        DllCall("SetCursorPos", "Int", x, "Int", y)

        Sleep interval
    }
}

; ==============================
; 🔒 값 제한 함수
; ==============================
Clamp(val, min, max)
{
    return val < min ? min : (val > max ? max : val)
}