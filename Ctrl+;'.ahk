#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; 툴팁 표시 함수
; ==============================
ShowTooltip(msg) {
    ToolTip msg
    SetTimer RemoveTooltip, -800
}
RemoveTooltip() {
    ToolTip
}

; ==============================
; Ctrl + ; → Ctrl + Left
; Ctrl + Shift + ; → Ctrl + Shift + Left (블록 선택)
; ==============================
^`;:: {
    Send("{Ctrl Down}{Left}{Ctrl Up}")
    ShowTooltip("Ctrl + Left")
}

^+`;:: {
    Send("{Ctrl Down}{Shift Down}{Left}{Shift Up}{Ctrl Up}")
    ShowTooltip("Ctrl + Shift + Left (블록 선택)")
}

; ==============================
; Ctrl + ' → Ctrl + Right
; Ctrl + Shift + ' → Ctrl + Shift + Right (블록 선택)
; ==============================
^SC028:: {
    Send("{Ctrl Down}{Right}{Ctrl Up}")
    ShowTooltip("Ctrl + Right")
}

^+SC028:: {
    Send("{Ctrl Down}{Shift Down}{Right}{Shift Up}{Ctrl Up}")
    ShowTooltip("Ctrl + Shift + Right (블록 선택)")
}