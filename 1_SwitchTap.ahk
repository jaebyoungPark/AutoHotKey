#Requires AutoHotkey v2.0

; -----------------------------------------
; CapsLock + Left → Ctrl + Shift + Tab
; -----------------------------------------
$Left::
{
    if GetKeyState("CapsLock", "T")  ; CapsLock이 켜져 있는지 확인
    {
        SendInput("^+{Tab}")  ; Ctrl + Shift + Tab
        return
    }
    else
    {
        Send "{Left}"  ; CapsLock 안 켜져 있으면 일반 Left
        return
    }
}

; -----------------------------------------
; CapsLock + Right → Ctrl + Tab
; -----------------------------------------
$Right::
{
    if GetKeyState("CapsLock", "T")  ; CapsLock이 켜져 있는지 확인
    {
        SendInput("^({Tab})")  ; Ctrl + Tab
        return
    }
    else
    {
        Send "{Right}"  ; CapsLock 안 켜져 있으면 일반 Right
        return
    }
}