#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키
; ==============================

!j::
{
    Send "{Alt Down}{Left}"
}

!l::
{
    Send "{Alt Down}{Right}"
}

!i::
{
    Send "{Alt Down}{Up}"
}

!k::
{
    Send "{Alt Down}{Down}"
}


; ==============================
; 파일 탐색기일 때만 WASD 사용
; ==============================

!a::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Left}"
    }
}

!d::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Right}"
    }
}

!w::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Up}"
    }
}

!s::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Down}"
    }
}