#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키
; ==============================

$!j::
{
    Send "{Alt Down}{Left}"
}

$!l::
{
    Send "{Alt Down}{Right}"
}

$!i::
{
    Send "{Alt Down}{Up}"
}

$!k::
{
    Send "{Alt Down}{Down}"
}


; ==============================
; 파일 탐색기 / 크롬 전용 단축키
; ==============================

$!a::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Left}"
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Down 2}"
    }
    ; 기타 프로그램
    else
    {
        Send "!a"
    }
}

$!d::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Right}"
    }
    ; 기타 프로그램
    else
    {
        Send "!d"
    }
}

$!w::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Up}"
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Up}"
    }
    ; 기타 프로그램
    else
    {
        Send "!w"
    }
}

$!s::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Down}"
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Down}"
    }
    ; 기타 프로그램
    else
    {
        Send "!s"
    }
}

$!q::
{
    ; 크롬
    if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Up 2}"
    }
    ; 기타 프로그램
    else
    {
        Send "!q"
    }
}

$!e::
{
    ; 크롬
    if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Enter}"
    }
    ; 기타 프로그램
    else
    {
        Send "!e"
    }
}