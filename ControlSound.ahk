#Requires AutoHotkey v2.0

!WheelUp:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("{Volume_Up}")
    }
}

!WheelDown:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("{Volume_Down}")
    }
}