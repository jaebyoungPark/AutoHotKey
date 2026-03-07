$^m::
{
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^m"
        return
    }

    start := A_TickCount
    KeyWait "m"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.2)
    {
        ShowCtrlTTip('📂 기본 Ctrl+M 실행 (' Round(elapsed,2) 's)')
        Send "^m"
    }
    else if (elapsed <= 0.55)
    {
        ShowCtrlTTip('⌨ Montage 입력 (' Round(elapsed,2) 's)')
        SendText "Montage"
    }
    else
    {
        ShowCtrlTTip('⏳ 0.55초 초과 - 동작 없음 (' Round(elapsed,2) 's)')
    }
}