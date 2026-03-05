#Requires AutoHotkey v2.0

ShowCtrlTTip(msg)
{
    ToolTip msg
    SetTimer () => ToolTip(), -600
}

$^t::
{
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^t"
        return
    }

    start := A_TickCount
    KeyWait "t"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.2)
    {
        ShowCtrlTTip('📂 기본 Ctrl+T 실행 (' Round(elapsed,2) 's)')
        Send "^t"
    }
    else if (elapsed <= 0.55)
    {
        ShowCtrlTTip('⌨ TEXT("") 입력 (' Round(elapsed,2) 's)')
        SendText 'TEXT("")'
        Send "{Left 2}"
    }
    else
    {
        ShowCtrlTTip('⏳ 0.55초 초과 - 동작 없음 (' Round(elapsed,2) 's)')
    }
}