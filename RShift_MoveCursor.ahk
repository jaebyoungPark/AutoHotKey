#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Screen"
; ==============================
; 🔧 전역 설정값
; ==============================
global MoveStepNormalSlow := 3.0
global MoveStepNormalFast := 7.5
global NormalAccelTime    := 350
global MoveInterval       := 10
global VerticalRatio      := 0.7  ; 대각선 이동 시 수직 비율
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
; 🔹 툴팁 함수
; ==============================
ShowTooltip(msg) {
    ToolTip msg
    SetTimer RemoveTooltip, -800
}
RemoveTooltip() {
    ToolTip
}
; ==============================
; 🔹 방향키 이동 함수
; ==============================
SendArrow(key, amount, withShift := false) {
    if (withShift)
        Send "+{" key " " amount "}"
    else
        Send "{" key " " amount "}"
}
; ==============================
; 🔹 시간 기반 처리 함수
; ==============================
HandleShiftKey(key, shortAction, longAction, longActionWithShift := "", shortMsg := "", shortShiftMsg := "", longMsg := "", longShiftMsg := "") {
    start := A_TickCount
    isLShift := GetKeyState("LShift", "P")
    isAlt := GetKeyState("Alt", "P")
    while GetKeyState("RShift", "P") && GetKeyState(key, "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000
    if (elapsed < 0.25) {
        if (isAlt) {
            shortAction(false, true)
        } else if (isLShift) {
            shortAction(true, false)
            if (shortShiftMsg != "")
                ShowTooltip(shortShiftMsg)
        } else {
            shortAction(false, false)
            if (shortMsg != "")
                ShowTooltip(shortMsg)
        }
    } else {
        if (longActionWithShift != "" && isLShift) {
            longActionWithShift()
            if (longShiftMsg != "")
                ShowTooltip(longShiftMsg)
        } else {
            longAction()
            if (longMsg != "")
                ShowTooltip(longMsg)
        }
    }
}
; ==============================
; ▶ RShift + 1칸 이동 (a/s/d/f)
; ==============================
RShift & a:: HandleShiftKey("a"
    , (s, alt) => alt ? (Send("!{Left}"),  ShowTooltip("⬅ 단어 뒤로"))
                      : SendArrow("Left", 1, s)
    , () => Send("{Home}")
    , () => Send("+{Home}")
    , "◀ 1칸"
    , "◀ 1칸 선택"
    , "⏮ 줄 처음"
    , "⏮ 줄 처음까지 선택"
)
RShift & s:: HandleShiftKey("s"
    , (s, alt) => alt ? (Send("!{Right}"), ShowTooltip("📋 멤버 목록 열기"))
                      : SendArrow("Right", 1, s)
    , () => Send("{End}")
    , () => Send("+{End}")
    , "▶ 1칸"
    , "▶ 1칸 선택"
    , "⏭ 줄 끝"
    , "⏭ 줄 끝까지 선택"
)
RShift & d:: HandleShiftKey("d"
    , (s, alt) => SendArrow("Up", 1, s)
    , () => Send("{PgUp}")
    , ""
    , "▲ 1칸"
    , "▲ 1칸 선택"
    , "⏫ 페이지 위로"
)
RShift & f:: HandleShiftKey("f"
    , (s, alt) => SendArrow("Down", 1, s)
    , () => Send("{PgDn}")
    , ""
    , "▼ 1칸"
    , "▼ 1칸 선택"
    , "⏬ 페이지 아래로"
)
; ==============================
; ▶ RShift + 3칸 이동 (q/w/e/r)
; ==============================
RShift & q:: HandleShiftKey("q"
    , (s, alt) => alt ? (Send("!{Left}"),  ShowTooltip("⬅ 단어 뒤로"))
                      : SendArrow("Left", 3, s)
    , () => Send("{Home}")
    , () => Send("+{Home}")
    , "◀◀ 3칸"
    , "◀◀ 3칸 선택"
    , "⏮ 줄 처음"
    , "⏮ 줄 처음까지 선택"
)
RShift & w:: HandleShiftKey("w"
    , (s, alt) => alt ? (Send("!{Right}"), ShowTooltip("📋 멤버 목록 열기"))
                      : SendArrow("Right", 3, s)
    , () => Send("{End}")
    , () => Send("+{End}")
    , "▶▶ 3칸"
    , "▶▶ 3칸 선택"
    , "⏭ 줄 끝"
    , "⏭ 줄 끝까지 선택"
)
RShift & e:: HandleShiftKey("e"
    , (s, alt) => SendArrow("Up", 3, s)
    , () => Send("{PgUp}")
    , ""
    , "▲▲ 3칸"
    , "▲▲ 3칸 선택"
    , "⏫ 페이지 위로"
)
RShift & r:: HandleShiftKey("r"
    , (s, alt) => SendArrow("Down", 3, s)
    , () => Send("{PgDn}")
    , ""
    , "▼▼ 3칸"
    , "▼▼ 3칸 선택"
    , "⏬ 페이지 아래로"
)
; ==============================
; 🖱 RShift + Z/X/C/V (마우스 이동)
; ==============================
RShift & z::MoveMouseRShift()
RShift & x::MoveMouseRShift()
RShift & c::MoveMouseRShift()
RShift & v::MoveMouseRShift()
; ==============================
; 🧠 마우스 이동 함수 (중간 가속)
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
            baseStep := (elapsed < NormalAccelTime) ? MoveStepNormalSlow * 0.5 : MoveStepNormalSlow
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
