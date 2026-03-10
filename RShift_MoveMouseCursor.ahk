#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"
; ==============================
; 🔧 전역 설정값 (RShift 단독)
; ==============================
global MoveStepNormalSlow := 3.0
global MoveStepNormalFast := 7.5
global NormalAccelTime   := 350
global MoveInterval      := 10
global VerticalRatio     := 0.7  ; 대각선 이동 시 수직 비율
; ==============================
; 📐 좌표 제한 (RShift 전용)
; ==============================
ClampRShift(val, min, max)
{
    return val < min ? min : (val > max ? max : val)
}
; ==============================
; 🔒 RShift 단독 방지
; ==============================
~RShift::Return
; ==============================
; 🖱 RShift + Z/X/C/V (중간 가속)
; ==============================
RShift & z::MoveMouseRShift()
RShift & x::MoveMouseRShift()
RShift & c::MoveMouseRShift()
RShift & v::MoveMouseRShift()
; ==============================
; 🧠 RShift 단독 (중간 가속 이동)
; ==============================
MoveMouseRShift()
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
    while (GetKeyState("RShift", "P"))
    {
        isLeft  := GetKeyState("z", "P")
        isRight := GetKeyState("x", "P")
        isUp    := GetKeyState("c", "P")
        isDown  := GetKeyState("v", "P")
        if (!isLeft && !isRight && !isUp && !isDown)
            break
        elapsed := A_TickCount - startTime
        ; --- 기본 속도 결정 ---
        if (GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
        {
            ; Win 누르면 느리게 (정밀 이동)
            baseStep := (elapsed < NormalAccelTime) ? MoveStepNormalSlow : MoveStepNormalSlow * 2
        }
        else
        {
            ; RShift 단독: 빠르게
            baseStep := (elapsed < NormalAccelTime) ? MoveStepNormalFast : MoveStepNormalFast * 2
        }
        step := baseStep
        ; 대각선 이동 감지
        isDiagonal := (isLeft || isRight) && (isUp || isDown)
        verticalStep := isDiagonal ? (step * VerticalRatio) : step
        ; 현재 커서 위치 가져오기
        DllCall("GetCursorPos", "Ptr", pt)
        x := NumGet(pt, 0, "Int")
        y := NumGet(pt, 4, "Int")
        ; 이동값 누적
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
        ; 화면 좌표 제한
        x := ClampRShift(x, VX, MaxX)
        y := ClampRShift(y, VY, MaxY)
        ; 커서 이동
        DllCall("SetCursorPos", "Int", x, "Int", y)
        Sleep MoveInterval
    }
}