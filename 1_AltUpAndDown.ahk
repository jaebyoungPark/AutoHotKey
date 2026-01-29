#Requires AutoHotkey v2.0

; ========================================
; Ctrl + ↑ → Alt + ↑ (VS에서만, Ctrl+↑ 원래 동작 차단)
; ========================================
^Up::
{
    if WinActive("ahk_exe devenv.exe")  ; Visual Studio만
        SendInput("!{Up}")              ; Alt + Up
    return
}

; ========================================
; Ctrl + ↓ → Alt + ↓ (VS에서만, Ctrl+↓ 원래 동작 차단)
; ========================================
^Down::
{
    if WinActive("ahk_exe devenv.exe")  ; Visual Studio만
        SendInput("!{Down}")            ; Alt + Down
    return
}