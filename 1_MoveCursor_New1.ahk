#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"

; ==============================
; 🔧 전역 설정값
; ==============================

; ▶ Win 단독 (가속 중간 속도)
global MoveStepNormalSlow := 3.5    ; 처음 느린 속도
global MoveStepNormalFast := 7     ; 가속 후 속도
global NormalAccelTime   := 450    ; 가속 시작(ms)

; ▶ Win + Alt (고속 고정)
global MoveStepFast      := 30
global MoveIntervalFast  := 8

; ▶ Win + Ctrl (미세 가속)
global MoveStepFine      := 1.5
global MoveStepUltraFine := 0.5
global FineAccelTime     := 200

; ▶ 공통
global MoveInterval      := 10
global MoveIntervalFine  := 5

; ==============================
; 🔒 Win 키 단독 방지
; ==============================
~LWin::Return
~RWin::Return

; ==============================
; 🖱 Win + 방향키 (가속 중간)
; ==============================
#Left::  MoveMouseNormal()
#Right:: MoveMouseNormal()
#Up::    MoveMouseNormal()
#Down::  MoveMouseNormal()

; ==============================
; 🖱 Win + Ctrl + 방향키 (미세)
; ==============================
#^Left::  MoveMouseFine()
#^Right:: MoveMouseFine()
#^Up::    MoveMouseFine()
#^Down::  MoveMouseFine()

; ==============================
; 🖱 Win + Alt + 방향키 (고속)
; ==============================
#!Left::  MoveMouseFast()
#!Right:: MoveMouseFast()
#!Up::    MoveMouseFast()
#!Down::  MoveMouseFast()

; ==============================
; 🧠 Win 단독 (가속 이동)
; ==============================
MoveMouseNormal()
{
    global MoveStepNormalSlow, MoveStepNormalFast
    global NormalAccelTime, MoveInterval

    startTime := A_TickCount

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)
    accX := 0.0
    accY := 0.0

    while (GetKeyState("LWin", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        elapsed := A_TickCount - startTime
        step := (elapsed < NormalAccelTime)
            ? MoveStepNormalSlow
            : MoveStepNormalFast

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

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

        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        DllCall("SetCursorPos", "Int", x, "Int", y)
        Sleep MoveInterval
    }
}

; ==============================
; 🧠 Win + Alt (고속 이동)
; ==============================
MoveMouseFast()
{
    global MoveStepFast, MoveIntervalFast
    MoveMouseFixedSpeed(MoveStepFast, MoveIntervalFast)
}

; ==============================
; 🧠 고정 속도 공용 로직
; ==============================
MoveMouseFixedSpeed(step, interval)
{
    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)
    accX := 0.0
    accY := 0.0

    while (GetKeyState("LWin", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

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

        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        DllCall("SetCursorPos", "Int", x, "Int", y)
        Sleep interval
    }
}

; ==============================
; 🧠 Win + Ctrl (미세 이동)
; ==============================
MoveMouseFine()
{
    global MoveStepFine, MoveStepUltraFine
    global MoveIntervalFine, FineAccelTime

    startTime := A_TickCount

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)
    accX := 0.0
    accY := 0.0

    while (GetKeyState("LWin", "P") && GetKeyState("Ctrl", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        elapsed := A_TickCount - startTime
        step := (elapsed < FineAccelTime)
            ? MoveStepUltraFine
            : MoveStepFine

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

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

        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        DllCall("SetCursorPos", "Int", x, "Int", y)
        Sleep MoveIntervalFine
    }
}

; ==============================
; 📐 좌표 제한
; ==============================
Clamp(val, min, max)
{
    return val < min ? min : (val > max ? max : val)
}