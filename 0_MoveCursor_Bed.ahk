; ==============================
; 🔒 VK15 단독 입력 방지
; ==============================
~VK15::Return

; ==============================
; VK15 + WASD → 마우스 이동
; VK15 는 한영키랑 겹치는 키라서, 일반적으론 불편할 수 있기 때문에 Include.ahk 에 포함하지 않음. 따라서 사용 시 별도로 실행해야 함.
; ==============================
VK15 & w::MoveMouseVK15()
VK15 & a::MoveMouseVK15()
VK15 & s::MoveMouseVK15()
VK15 & d::MoveMouseVK15()

; ==============================
; 🖱️ 마우스 이동 함수
; ==============================
MoveMouseVK15()
{
    ; 🔥 fallback (Main 없어도 동작)
    global MoveStepNormalFast := MoveStepNormalFast ?? 7.5
    global MoveInterval       := MoveInterval ?? 10
    global VerticalRatio      := VerticalRatio ?? 0.7

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)

    accX := 0.0
    accY := 0.0

    ; 👉 로컬 Clamp (외부 의존 제거)
    Clamp(val, min, max)
    {
        return val < min ? min : (val > max ? max : val)
    }

    while (GetKeyState("VK15", "P"))
    {
        isLeft  := GetKeyState("a", "P")
        isRight := GetKeyState("d", "P")
        isUp    := GetKeyState("w", "P")
        isDown  := GetKeyState("s", "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        ; 🔥 속도 모드
        isLAlt   := GetKeyState("LAlt", "P")
        isLShift := GetKeyState("LShift", "P")

        if (isLAlt)
            baseStep := 0.5
        else if (isLShift)
            baseStep := MoveStepNormalFast * 4
        else
            baseStep := MoveStepNormalFast

        step := baseStep

        ; 대각선 보정
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

        ; 🔥 내부 Clamp 사용
        x := Clamp(x, VX, MaxX)
        y := Clamp(y, VY, MaxY)

        DllCall("SetCursorPos", "Int", x, "Int", y)

        Sleep MoveInterval
    }
}