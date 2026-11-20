#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf GetKeyState("Alt", "P")

CapsLock & w:: {
    ToolTip("!CapsLock.ahk")
    SetTimer(() => ToolTip(), -500)

    Run("chrome.exe")
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

CapsLock & e:: {
    ToolTip("SOOP")
    SetTimer(() => ToolTip(), -500)

    if hwnd := WinExist("장지수 - SOOP ahk_exe chrome.exe")
        WinActivate("ahk_id " hwnd)
    else
        Run("https://www.sooplive.com/")

    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

CapsLock & d:: {
    ToolTip("123AV")
    SetTimer(() => ToolTip(), -500)

    Run("https://123av.com/ko")
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

CapsLock & s:: {
    ToolTip("Javtiful")
    SetTimer(() => ToolTip(), -500)

    Run("https://javtiful.com/ko/videos")
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}

CapsLock & a:: {
    ToolTip("OneJAV")
    SetTimer(() => ToolTip(), -500)

    Run("https://onejav.com/")
    SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
}
#HotIf

