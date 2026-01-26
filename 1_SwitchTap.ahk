#Requires AutoHotkey v2.0

; -----------------------------------------
; Left → Ctrl + Shift + Tab
; -----------------------------------------
$Left::
{
    SendInput("^+{Tab}")  ; Ctrl + Shift + Tab
}

; -----------------------------------------
; Right → Ctrl + Tab
; -----------------------------------------
$Right::
{
    SendInput("^{Tab}")  ; Ctrl + Tab
}