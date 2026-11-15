#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf GetKeyState("Alt", "P")

CapsLock & w:: {
    Run("chrome.exe")
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

#HotIf