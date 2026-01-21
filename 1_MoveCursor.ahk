#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode "Mouse", "Screen"

; ==============================
; 🔧 전역 설정값
; ==============================
global MoveStepSlow      := 5
global MoveStep          := 40
global MoveStepFine      := 1.5
global MoveStepUltraFine := 0.5    ; 🪡 미세조정 초반 초미세

global MoveInterval      := 10
global MoveIntervalFine  := 5

global AccelTime         := 500    ; 일반 이동 가속 시작
global PreAccelPause     := 150    ; 일반 이동 가속 직전 멈춤(ms)

global FineAccelTime     := 200    ; 🧠 미세조정 가속 시작 (0.2초)

; ==============================
; 🔒 Win 키 단독 방지
; ==============================
~LWin::Return
~RWin::Return

; ==============================
; 🖱 이동
; ==============================
#Left::  MoveMouse(false)
#Right:: MoveMouse(false)
#Up::    MoveMouse(false)
#Down::  MoveMouse(false)

#^Left::  MoveMouse(true)
#^Right:: MoveMouse(true)
#^Up::    MoveMouse(true)
#^Down::  MoveMouse(true)

; ==============================
; 🧠 커서 이동
; ==============================
MoveMouse(isFineMode := false)
{
    global MoveStepSlow, MoveStep, MoveStepFine, MoveStepUltraFine
    global MoveInterval, MoveIntervalFine
    global AccelTime, PreAccelPause, FineAccelTime

    startTime := A_TickCount
    interval  := isFineMode ? MoveIntervalFine : MoveInterval
    paused := false  ; 일반 이동 가속 직전 정지 여부

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)
    accX := 0.0
    accY := 0.0

    while (GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        elapsed := A_TickCount - startTime

        ; 🎯 이동 단계 결정
        if (isFineMode)
        {
            if (elapsed < FineAccelTime)
                step := MoveStepUltraFine   ; 초반 초미세
            else
                step := MoveStepFine        ; 이후 살짝 가속
        }
        else if (elapsed < AccelTime - PreAccelPause)
        {
            step := MoveStepSlow
        }
        else if (!paused && elapsed < AccelTime)
        {
            paused := true
            Sleep PreAccelPause     ; 가속 직전 브레이크
            continue
        }
        else
        {
            step := MoveStep
        }

        ; 🪡 현재 커서 위치 읽기
        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

        ; 🔄 소수 누적 계산
        if (isLeft)
            accX -= step
        if (isRight)
            accX += step
        if (isUp)
            accY -= step
        if (isDown)
            accY += step

        dx := Floor(accX)
        dy := Floor(accY)
        accX -= dx
        accY -= dy

        x += dx
        y += dy

        ; 📐 화면 범위 제한
        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        ; 🖱 커서 이동
        DllCall("SetCursorPos", "Int", x, "Int", y)
        Sleep interval
    }
}

; ==============================
; 📐 좌표 제한
; ==============================
Clamp(val, min, max)
{
    return val < min ? min : (val > max ? max : val)
}