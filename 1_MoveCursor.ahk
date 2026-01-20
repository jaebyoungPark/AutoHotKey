#Requires AutoHotkey v2.0
CoordMode "Mouse", "Screen"

MoveStepSlow := 8        ; ⏳ 처음 느린 속도
MoveStep := 40           ; 🚀 기본 속도
MoveStepFine := 2        ; 🎯 미세 이동
MoveInterval := 10
MoveIntervalFine := 5
AccelTime := 300         ; ⏱️ 0.3초 후 가속

~LWin::Return
~RWin::Return

#Left::  MoveMouse("Left", false)
#Right:: MoveMouse("Right", false)
#Up::    MoveMouse("Up", false)
#Down::  MoveMouse("Down", false)

#^Left::  MoveMouse("Left", true)
#^Right:: MoveMouse("Right", true)
#^Up::    MoveMouse("Up", true)
#^Down::  MoveMouse("Down", true)

MoveMouse(dir, isFineMode := false)
{
    global MoveStepSlow, MoveStep, MoveStepFine
    global MoveInterval, MoveIntervalFine, AccelTime
    
    startTime := A_TickCount
    interval := isFineMode ? MoveIntervalFine : MoveInterval
    
    ; 가상 화면 정보
    VX := SysGet(76)
    VY := SysGet(77)
    VW := SysGet(78)
    VH := SysGet(79)
    
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1
    
    while (GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
    {
        ; 대각선 이동 감지
        isLeft := GetKeyState("Left", "P")
        isRight := GetKeyState("Right", "P")
        isUp := GetKeyState("Up", "P")
        isDown := GetKeyState("Down", "P")
        
        ; 아무 방향키도 안 눌렀으면 종료
        if (!isLeft && !isRight && !isUp && !isDown)
            break
        
        elapsed := A_TickCount - startTime
        
        ; ⏱️ 가속 로직
        if (isFineMode)
            step := MoveStepFine
        else if (elapsed < AccelTime)
            step := MoveStepSlow
        else
            step := MoveStep
        
        MouseGetPos &x, &y
        
        ; 대각선 이동 처리
        if (isLeft)
            x -= step
        if (isRight)
            x += step
        if (isUp)
            y -= step
        if (isDown)
            y += step
        
        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)
        
        MouseMove x, y, 0
        Sleep interval
    }
}

Clamp(val, min, max)
{
    return val < min ? min : (val > max ? max : val)
}