#Requires AutoHotkey v2

ShowCtrl2Tip(msg)
{
    ToolTip msg
    SetTimer () => ToolTip(), -700
}

$^2::
{
    ; Visual Studio 아닐 때 → 기본 Ctrl+2
    if !WinActive("ahk_exe devenv.exe")
    {
        Send "^2"
        return
    }

    start := A_TickCount
    KeyWait "2"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2초 미만 → *.ToString()
    if (elapsed < 0.2)
    {
        ShowCtrl2Tip("⌨ *.ToString() 입력")
        SendText ", *.ToString()" 
        Send "{Left 11}"
        return
    }

    ; 0.2 ~ 0.55초 → [] : %s
    if (elapsed <= 0.55)
    {
        ShowCtrl2Tip("⌨ [] : %s 입력")
        SendText ", [] : %s" 
        Send "{Left 6}"
        return
    }
}