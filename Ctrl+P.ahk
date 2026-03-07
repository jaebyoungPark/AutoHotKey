#Requires AutoHotkey v2.0

$^p::
{
    ; Visual Studio 아닐 경우 기본동작
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^p"
        return
    }

    start := A_TickCount
    KeyWait "p"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.15)
    {
        SendText "public:"
    }
    else if (elapsed < 0.3)
    {
        SendText "protected:"
    }
    else
    {
        SendText "private:"
    }
}