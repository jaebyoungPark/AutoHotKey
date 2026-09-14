#Requires AutoHotkey v2.0

; ==============================
; Win + D → Ctrl + Alt + Shift + O
; ==============================
#d::
{
    ToolTip("🔵 Win + D 감지됨`n→ Ctrl + Alt + Shift + O 실행")
    SetTimer(() => ToolTip(), -1500)

    ; 기존 Ctrl+Alt+Shift+O 핫키 실행
    SendEvent "^!+o"
}


; ==============================
; Win + E → Ctrl + Alt + Shift + P
; ==============================
#e::
{
    ToolTip("🟢 Win + E 감지됨`n→ HandleCtrlAltShiftP() 실행")
    SetTimer(() => ToolTip(), -1500)

    HandleCtrlAltShiftP()
}