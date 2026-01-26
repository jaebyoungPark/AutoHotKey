+Left::
{
    if WinActive("ahk_exe chrome.exe")
        Send "^+{Tab}"
    else
        Send "+{Left}"
}

+Right::
{
    if WinActive("ahk_exe chrome.exe")
        Send "^{Tab}"
    else
        Send "+{Right}"
}