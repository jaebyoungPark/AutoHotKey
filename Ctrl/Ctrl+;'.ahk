#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; 툴팁 표시 함수
; ==============================
ShowMyTooltip(msg) {
    ToolTip msg
    SetTimer RemoveMyTooltip, -800
}
RemoveMyTooltip() {
    ToolTip
}

; ==============================
; Ctrl + ; → Ctrl + Left
; Ctrl + Shift + ; → Ctrl + Shift + Left (블록 선택)
; ==============================
^`;:: {
    Send("{Ctrl Down}{Left}{Ctrl Up}")
    ShowMyTooltip("⬅ 단어 이동 (Ctrl + Left)")
}

^+`;:: {
    Send("{Ctrl Down}{Shift Down}{Left}{Shift Up}{Ctrl Up}")
    ShowMyTooltip("⬅ 단어 블록 선택 (Ctrl + Shift + Left)")
}

; ==============================
; Ctrl + ' → Ctrl + Right
; Ctrl + Shift + ' → Ctrl + Shift + Right (블록 선택)
; ==============================
^SC028:: {
    Send("{Ctrl Down}{Right}{Ctrl Up}")
    ShowMyTooltip("➡ 단어 이동 (Ctrl + Right)")
}

^+SC028:: {
    Send("{Ctrl Down}{Shift Down}{Right}{Shift Up}{Ctrl Up}")
    ShowMyTooltip("➡ 단어 블록 선택 (Ctrl + Shift + Right)")
}