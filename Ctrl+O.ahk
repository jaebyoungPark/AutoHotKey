$^o::
{
    ; Visual Studio가 아니면 원래 동작
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^o"
        return
    }

    start := A_TickCount
    KeyWait "o"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed >= 0.2)
    {
        SendText "override"
    }
    else
    {
        Send "^o"
    }
}