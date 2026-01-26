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

; ▶ Win + Ctrl (고속 가속) ← 원래 Alt 기능
global MoveStepFastSlow := 11
global MoveStepFastFast := 25
global FastAccelTime   := 250
global MoveIntervalFast := 8

; ▶ Win + Alt (미세 가속) ← 원래 Ctrl 기능
global MoveStepFine      := 1.5
global MoveStepUltraFine := 0.5
global FineAccelTime     := 200

; ▶ 공통
global MoveInterval      := 10
global MoveIntervalFine  := 5

; ▶ 대각선 이동 시 수직 비율 (0.0 ~ 1.0)
global VerticalRatio := 0.7  ; 70%로 감소 (기본값 1.0 = 100%)

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
; 🖱 Win + Ctrl + 방향키 (고속) ← 변경됨!
; ==============================
#^Left::  MoveMouseFastAccel()
#^Right:: MoveMouseFastAccel()
#^Up::    MoveMouseFastAccel()
#^Down::  MoveMouseFastAccel()

; ==============================
; 🖱 Win + Alt + 방향키 (미세) ← 변경됨!
; ==============================
#!Left::  MoveMouseFine()
#!Right:: MoveMouseFine()
#!Up::    MoveMouseFine()
#!Down::  MoveMouseFine()

; ==============================
; 🧠 Win 단독 (중간 가속 이동)
; ==============================
MoveMouseNormal()
{
    global MoveStepNormalSlow, MoveStepNormalFast
    global NormalAccelTime, MoveInterval, VerticalRatio

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

        ; 대각선 이동 감지
        isDiagonal := (isLeft || isRight) && (isUp || isDown)
        verticalStep := isDiagonal ? (step * VerticalRatio) : step

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

        if (isLeft)
            accX -= step
        if (isRight)
            accX += step
        if (isUp)
            accY -= verticalStep
        if (isDown)
            accY += verticalStep

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
; 🧠 Win + Ctrl (고속 가속 이동) ← 변경됨!
; ==============================
MoveMouseFastAccel()
{
    global MoveStepFastSlow, MoveStepFastFast
    global FastAccelTime, MoveIntervalFast, VerticalRatio

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
        step := (elapsed < FastAccelTime)
            ? MoveStepFastSlow
            : MoveStepFastFast

        ; 대각선 이동 감지
        isDiagonal := (isLeft || isRight) && (isUp || isDown)
        verticalStep := isDiagonal ? (step * VerticalRatio) : step

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

        if (isLeft)
            accX -= step
        if (isRight)
            accX += step
        if (isUp)
            accY -= verticalStep
        if (isDown)
            accY += verticalStep

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
; 🧠 Win + Alt (미세 가속 이동) ← 변경됨!
; ==============================
MoveMouseFine()
{
    global MoveStepFine, MoveStepUltraFine
    global MoveIntervalFine, FineAccelTime, VerticalRatio

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
        step := (elapsed < FineAccelTime)
            ? MoveStepUltraFine
            : MoveStepFine

        ; 대각선 이동 감지
        isDiagonal := (isLeft || isRight) && (isUp || isDown)
        verticalStep := isDiagonal ? (step * VerticalRatio) : step

        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")

        if (isLeft)
            accX -= step
        if (isRight)
            accX += step
        if (isUp)
            accY -= verticalStep
        if (isDown)
            accY += verticalStep

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