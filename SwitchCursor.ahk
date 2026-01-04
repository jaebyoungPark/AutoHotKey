#Requires AutoHotkey v2.0

$RButton::
{
    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.25)
    {
        ; 기본 우클릭
        Send "{RButton}"
    }
    else if (elapsed < 5.0)
    {
        ; Ctrl + Win + .
        Send "^#."
    }
}