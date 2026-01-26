+Delete::
{
    if WinActive("ahk_exe chrome.exe")
    {
        Send "^+{Tab}"
        ToolTip "탭 왼쪽"
        SetTimer () => ToolTip(), -500
    }
    else
        Send "+{Delete}"
}

+End::
{
    if WinActive("ahk_exe chrome.exe")
    {
        Send "^{Tab}"
        ToolTip "탭 오른쪽"
        SetTimer () => ToolTip(), -500
    }
    else
        Send "+{End}"
}