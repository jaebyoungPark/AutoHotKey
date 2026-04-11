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
; ==============================
; ▶ RShift + q (왼쪽 이동) - 3단계
; ==============================
RShift & q::
{
    start := A_TickCount
    isLShift := GetKeyState("LShift", "P")
    isAlt := GetKeyState("Alt", "P")
    while GetKeyState("RShift", "P") && GetKeyState("q", "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000

    if (elapsed < 0.25) {
        if (isAlt) {
            Send("!{Left}")
            ShowTooltip("⬅ 단어 뒤로")
        } else {
            SendArrow("Left", 3, isLShift)
            ShowTooltip(isLShift ? "◀◀ 3칸 선택" : "◀◀ 3칸")
        }
    } else if (elapsed < 0.5) {
        if (isLShift) {
            Send("+{Left 12}")
            ShowTooltip("⏮ 12칸 선택")
        } else {
            SendArrow("Left", 12)
            ShowTooltip("⏮ 12칸")
        }
    } else {
        if (isLShift) {
            Send("+{Left 30}")
            ShowTooltip("⏮⏮ 30칸 선택")
        } else {
            SendArrow("Left", 30)
            ShowTooltip("⏮⏮ 30칸")
        }
    }
}

; ==============================
; ▶ RShift + w (오른쪽 이동) - 3단계
; ==============================
RShift & w::
{
    start := A_TickCount
    isLShift := GetKeyState("LShift", "P")
    isAlt := GetKeyState("Alt", "P")
    while GetKeyState("RShift", "P") && GetKeyState("w", "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000

    if (elapsed < 0.25) {
        if (isAlt) {
            Send("!{Right}")
            ShowTooltip("➡ 멤버 목록 열기")
        } else {
            SendArrow("Right", 3, isLShift)
            ShowTooltip(isLShift ? "▶▶ 3칸 선택" : "▶▶ 3칸")
        }
    } else if (elapsed < 0.5) {
        if (isLShift) {
            Send("+{Right 12}")
            ShowTooltip("⏭ 12칸 선택")
        } else {
            SendArrow("Right", 12)
            ShowTooltip("⏭ 12칸")
        }
    } else {
        if (isLShift) {
            Send("+{Right 30}")
            ShowTooltip("⏭⏭ 30칸 선택")
        } else {
            SendArrow("Right", 30)
            ShowTooltip("⏭⏭ 30칸")
        }
    }
}

; ==============================
; ▶ RShift + e (위 이동) - 3단계
; ==============================
RShift & e::
{
    start := A_TickCount
    isLShift := GetKeyState("LShift", "P")
    while GetKeyState("RShift", "P") && GetKeyState("e", "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000

    if (elapsed < 0.25) {
        SendArrow("Up", 3, isLShift)
        ShowTooltip(isLShift ? "▲▲ 3칸 선택" : "▲▲ 3칸")
    } else if (elapsed < 0.5) {
        if (isLShift) {
            Send("+{Up 12}")
            ShowTooltip("⏫ 12칸 선택")
        } else {
            SendArrow("Up", 12)
            ShowTooltip("⏫ 12칸")
        }
    } else {
        if (isLShift) {
            Send("+{Up 30}")
            ShowTooltip("⏫⏫ 30칸 선택")
        } else {
            SendArrow("Up", 30)
            ShowTooltip("⏫⏫ 30칸")
        }
    }
}

; ==============================
; ▶ RShift + r (아래 이동) - 3단계
; ==============================
RShift & r::
{
    start := A_TickCount
    isLShift := GetKeyState("LShift", "P")
    while GetKeyState("RShift", "P") && GetKeyState("r", "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000

    if (elapsed < 0.25) {
        SendArrow("Down", 3, isLShift)
        ShowTooltip(isLShift ? "▼▼ 3칸 선택" : "▼▼ 3칸")
    } else if (elapsed < 0.5) {
        if (isLShift) {
            Send("+{Down 12}")
            ShowTooltip("⏬ 12칸 선택")
        } else {
            SendArrow("Down", 12)
            ShowTooltip("⏬ 12칸")
        }
    } else {
        if (isLShift) {
            Send("+{Down 30}")
            ShowTooltip("⏬⏬ 30칸 선택")
        } else {
            SendArrow("Down", 30)
            ShowTooltip("⏬⏬ 30칸")
        }
    }
}

; VK15 = 오른쪽 Alt (Right Alt, AltGr 키)
~VK15::Return

; VK15(오른쪽 Alt) + WASD → 마우스 이동
VK15 & w::MoveMouseVK15()
VK15 & a::MoveMouseVK15()
VK15 & s::MoveMouseVK15()
VK15 & d::MoveMouseVK15()

MoveMouseVK15()
{
    global MoveStepNormalSlow, MoveStepNormalFast
    global MoveInterval, VerticalRatio

    VX := SysGet(76), VY := SysGet(77)
    VW := SysGet(78), VH := SysGet(79)
    MaxX := VX + VW - 1
    MaxY := VY + VH - 1

    pt := Buffer(8)

    accX := 0.0
    accY := 0.0

    while (GetKeyState("VK15", "P"))
    {
        isLeft  := GetKeyState("a", "P")
        isRight := GetKeyState("d", "P")
        isUp    := GetKeyState("w", "P")
        isDown  := GetKeyState("s", "P")

        if (!isLeft && !isRight && !isUp && !isDown)
            break

        ; 🔥 속도 모드 분기
        isLAlt   := GetKeyState("LAlt", "P")    ; 초정밀
        isLShift := GetKeyState("LShift", "P")  ; 빠른 이동

        if (isLAlt)
        {
            baseStep := 0.5   ; 초정밀
        }
        else if (isLShift)
        {
            baseStep := MoveStepNormalFast * 4  ; 빠른 속도 (원하면 값 조절)
        }
        else
        {
            baseStep := MoveStepNormalFast      ; 기본 속도 (항상 일정)
        }

        step := baseStep

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

        x := ClampRShift(x, VX, MaxX)
        y := ClampRShift(y, VY, MaxY)

        DllCall("SetCursorPos", "Int", x, "Int", y)

        Sleep MoveInterval
    }
}