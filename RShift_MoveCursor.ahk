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
SendArrow(key, amount) {
    Send "{" key " " amount "}"
    ShowTooltip(key " " amount "칸 이동")
}

; ==============================
; 🔹 시간 기반 처리 함수
; ==============================
HandleShiftKey(key, shortAction, longAction) {
    start := A_TickCount
    while GetKeyState("RShift", "P") && GetKeyState(key, "P")
        Sleep 10

    elapsed := (A_TickCount - start) / 1000
    if (elapsed < 0.2)
        shortAction()
    else
        longAction()
}

; ==============================
; ▶ RShift + 1칸 이동 (a/s/d/f)
; ==============================
RShift & a:: HandleShiftKey("a"
    , () => SendArrow("Left", 1)
    , () => Send("{Home}")        ; 0.2초 이상: Home
)

RShift & s:: HandleShiftKey("s"
    , () => SendArrow("Right", 1)
    , () => Send("{End}")         ; 0.2초 이상: End
)

RShift & d:: HandleShiftKey("d"
    , () => SendArrow("Up", 1)
    , () => Send("{PgUp}")        ; 0.2초 이상: PgUp
)

RShift & f:: HandleShiftKey("f"
    , () => SendArrow("Down", 1)
    , () => Send("{PgDn}")        ; 0.2초 이상: PgDn
)

; ==============================
; ▶ RShift + 3칸 이동 (q/w/e/r)
; ==============================
RShift & q:: HandleShiftKey("q"
    , () => SendArrow("Left", 3)
    , () => Send("{Home}")
)

RShift & w:: HandleShiftKey("w"
    , () => SendArrow("Right", 3)
    , () => Send("{End}")
)

RShift & e:: HandleShiftKey("e"
    , () => SendArrow("Up", 3)
    , () => Send("{PgUp}")
)

RShift & r:: HandleShiftKey("r"
    , () => SendArrow("Down", 3)
    , () => Send("{PgDn}")
)