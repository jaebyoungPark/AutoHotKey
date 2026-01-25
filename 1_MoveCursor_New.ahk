#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"

; ==============================
; 🔧 전역 설정값
; ==============================

; ▶ Win 단독 (중간 가속)
global MoveStepNormalSlow := 3.0
global MoveStepNormalFast := 7.5
global NormalAccelTime   := 350

; ▶ Win + Alt (고속 가속)
global MoveStepFastSlow := 11
global MoveStepFastFast := 25
global FastAccelTime   := 250
global MoveIntervalFast := 8

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
; 🖱 Win + 방향키 (중간 가속)
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
; 🖱 Win + Alt + 방향키 (고속 가속)
; ==============================
#!Left::  MoveMouseFastAccel()
#!Right:: MoveMouseFastAccel()
#!Up::    MoveMouseFastAccel()
#!Down::  MoveMouseFastAccel()

; ==============================
; 🧠 Win 단독 (중간 가속 이동)
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
; 🧠 Win + Alt (고속 가속 이동)
; ==============================
MoveMouseFastAccel()
{
    global MoveStepFastSlow, MoveStepFastFast
    global FastAccelTime, MoveIntervalFast

    startTime := A_TickCount

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)
    accX := 0.0
    accY := 0.0

    while (GetKeyState("LWin", "P") && GetKeyState("Alt", "P"))
    {
        isLeft  := GetKeyState("Left",  "P")
        isRight := GetKeyState("Right", "P")
        isUp    := GetKeyState("Up",    "P")
        isDown  := GetKeyState("Down",  "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        elapsed := A_TickCount - startTime
        step := (elapsed < FastAccelTime)
            ? MoveStepFastSlow
            : MoveStepFastFast

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
        Sleep MoveIntervalFast
    }
}

; ==============================
; 🧠 Win + Ctrl (미세 가속 이동)
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