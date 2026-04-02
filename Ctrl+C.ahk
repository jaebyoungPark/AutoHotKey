#Requires AutoHotkey v2.0

ShowTip2(msg)
{
    ToolTip msg
    SetTimer () => ToolTip(), -600
}

$^c::
{
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^c"
        return
    }

    start := A_TickCount
    KeyWait "c"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.3)
    {
        ShowTip2("📋 복사 실행 (" Round(elapsed,2) "s)")
        Send "^c"
    }
    else if (elapsed <= 0.55)
    {
        ShowTip2("⌨ Character 입력 (" Round(elapsed,2) "s)")
        SendText "Character"
    }
    else if (elapsed <= 0.75)
    {
        ShowTip2("🏷 Category 입력 (" Round(elapsed,2) "s)")
        SendText "Category = "
    }
    else
    {
        ShowTip2("⏳ 0.55초 초과 (" Round(elapsed,2) "s)")
    }
}