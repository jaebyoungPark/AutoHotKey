^+F11::
{
    start := A_TickCount
    while GetKeyState("F11", "P")
        Sleep 10
    elapsed := A_TickCount - start

    ; 250ms 이하
    if (elapsed <= 250)
    {
        if WinActive("ahk_exe devenv.exe") ; Visual Studio
        {
            SendInput "^+f"
            Sleep 100
            SendInput "{Enter}"
        }
        else
        {
            SendInput "{Left}"
        }
    }
    ; 250 ~ 1000ms
    else if (elapsed <= 1000)
    {
        SendInput "^#{/}"
    }
}