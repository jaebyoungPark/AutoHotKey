^+F11::
{
    start := A_TickCount
    while GetKeyState("F11", "P")
        Sleep 10
    elapsed := A_TickCount - start

    ; 250ms 이하
    if (elapsed <= 250)
    {
        SendInput "{Left}"
    }
    ; 250 ~ 1000ms
    else if (elapsed <= 1000)
    {
        SendInput "^#{/}"
    }
}