#Requires AutoHotkey v2.0

ShowMoveTip(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -500
}

; ==============================
; Shift + Alt + Mouse Left
; ==============================
+!LButton::
{
    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ShowMoveTip("← 1칸 이동")
        Send "+{Left}"
    }
    else if (elapsed <= 0.3) {
        ShowMoveTip("← 5칸 이동")
        Send "+{Left 5}"
    }
    else if (elapsed < 3.0) {
        ShowMoveTip("← 10칸 이동")
        Send "+{Left 10}"
    }
}

; ==============================
; Shift + Alt + Mouse Right
; ==============================
+!RButton::
{
    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ShowMoveTip("→ 1칸 이동")
        Send "+{Right}"
    }
    else if (elapsed <= 0.3) {
        ShowMoveTip("→ 5칸 이동")
        Send "+{Right 5}"
    }
    else if (elapsed < 3.0) {
        ShowMoveTip("→ 10칸 이동")
        Send "+{Right 10}"
    }
}

; ==============================
; Alt + Shift + Left
; ==============================
!+Left::
{
    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ShowMoveTip("단어 ← 1칸")
        Send "!+{Left}"
    }
    else if (elapsed <= 0.3) {
        ShowMoveTip("단어 ← 5칸")
        Loop 5 {
            Send "!+{Left}"
        }
    }
    else if (elapsed < 3.0) {
        ShowMoveTip("단어 ← 10칸")
        Loop 10 {
            Send "!+{Left}"
        }
    }
}

; ==============================
; Alt + Shift + Right
; ==============================
!+Right::
{
    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ShowMoveTip("단어 → 1칸")
        Send "!+{Right}"
    }
    else if (elapsed <= 0.3) {
        ShowMoveTip("단어 → 5칸")
        Loop 5 {
            Send "!+{Right}"
        }
    }
    else if (elapsed < 3.0) {
        ShowMoveTip("단어 → 10칸")
        Loop 10 {
            Send "!+{Right}"
        }
    }
}