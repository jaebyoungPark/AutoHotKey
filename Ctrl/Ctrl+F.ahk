$^f::
{
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^f"
        return
    }

    start := A_TickCount
    KeyWait "f"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.2)
    {
        ShowCtrlTTip('🔍 기본 Ctrl+F 실행 (' Round(elapsed,2) 's)')
        Send "^f"
    }
    else if (elapsed <= 0.55)
    {
        ShowCtrlTTip('⌨ FVector 입력 (' Round(elapsed,2) 's)')
        SendText "FVector "
    }
    else
    {
        ShowCtrlTTip('⏳ 0.55초 초과 - 동작 없음 (' Round(elapsed,2) 's)')
    }
}