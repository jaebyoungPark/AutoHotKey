#Requires AutoHotkey v2.0

; ========================================
; Ctrl + ↑ → Alt + ↑ (VS에서만 추가, 원래 Ctrl + ↑ 유지)
; ========================================
~^Up::
{
    if WinActive("ahk_exe devenv.exe")  ; Visual Studio만
        SendInput("!{Up}")              ; Alt + Up 추가
    return
}

; ========================================
; Ctrl + ↓ → Alt + ↓ (VS에서만 추가, 원래 Ctrl + ↓ 유지)
; ========================================
~^Down::
{
    if WinActive("ahk_exe devenv.exe")  ; Visual Studio만
        SendInput("!{Down}")            ; Alt + Down 추가
    return
}