#Requires AutoHotkey v2.0
#SingleInstance Force
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
    while GetKeyState("RShift", "P") && GetKeyState(key, "P")
        Sleep 10
    elapsed := (A_TickCount - start) / 1000
    if (elapsed < 0.2) {
        if (isLShift) {
            shortAction(true)
            if (shortShiftMsg != "")
                ShowTooltip(shortShiftMsg)
        } else {
            shortAction(false)
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
    , (s) => (SendArrow("Left", 1, s))
    , () => Send("{Home}")
    , () => Send("+{Home}")
    , "◀ 1칸"
    , "◀ 1칸 선택"
    , "⏮ 줄 처음"
    , "⏮ 줄 처음까지 선택"
)
RShift & s:: HandleShiftKey("s"
    , (s) => (SendArrow("Right", 1, s))
    , () => Send("{End}")
    , () => Send("+{End}")
    , "▶ 1칸"
    , "▶ 1칸 선택"
    , "⏭ 줄 끝"
    , "⏭ 줄 끝까지 선택"
)
RShift & d:: HandleShiftKey("d"
    , (s) => SendArrow("Up", 1)
    , () => Send("{PgUp}")
    , ""
    , "▲ 1칸"
    , ""
    , "⏫ 페이지 위로"
)
RShift & f:: HandleShiftKey("f"
    , (s) => SendArrow("Down", 1)
    , () => Send("{PgDn}")
    , ""
    , "▼ 1칸"
    , ""
    , "⏬ 페이지 아래로"
)
; ==============================
; ▶ RShift + 3칸 이동 (q/w/e/r)
; ==============================
RShift & q:: HandleShiftKey("q"
    , (s) => SendArrow("Left", 3, s)
    , () => Send("{Home}")
    , () => Send("+{Home}")
    , "◀◀ 3칸"
    , "◀◀ 3칸 선택"
    , "⏮ 줄 처음"
    , "⏮ 줄 처음까지 선택"
)
RShift & w:: HandleShiftKey("w"
    , (s) => SendArrow("Right", 3, s)
    , () => Send("{End}")
    , () => Send("+{End}")
    , "▶▶ 3칸"
    , "▶▶ 3칸 선택"
    , "⏭ 줄 끝"
    , "⏭ 줄 끝까지 선택"
)
RShift & e:: HandleShiftKey("e"
    , (s) => SendArrow("Up", 3)
    , () => Send("{PgUp}")
    , ""
    , "▲▲ 3칸"
    , ""
    , "⏫ 페이지 위로"
)
RShift & r:: HandleShiftKey("r"
    , (s) => SendArrow("Down", 3)
    , () => Send("{PgDn}")
    , ""
    , "▼▼ 3칸"
    , ""
    , "⏬ 페이지 아래로"
)