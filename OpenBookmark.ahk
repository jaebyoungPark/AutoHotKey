#Requires AutoHotkey v2.0
#SingleInstance Force

$^+a::
{
if WinActive("ahk_exe devenv.exe")
{
    SendEvent "{Ctrl down}k{Ctrl up}"
    Sleep 10
    SendEvent "{Ctrl down}i{Ctrl up}"
    return
}

    ; Chrome
    if WinActive("ahk_exe chrome.exe")
    {
        start := A_TickCount
        KeyWait "a"
        elapsed := A_TickCount - start

        if (elapsed < 250)
            SendInput "{Blind}^+a"
        else if (elapsed < 550)
            SendInput "^b"

        return
    }

    ; 기타
    SendInput "{Blind}^+a"
}