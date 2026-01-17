HotkeyList := ["$^RButton"]

$^RButton::
{
    start := A_TickCount

    ; RButton 떼기까지 대기
    KeyWait "RButton"

    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed >= 0.25)
    {
        ; Ctrl + Win + /
        Send "^#/"
    }
}