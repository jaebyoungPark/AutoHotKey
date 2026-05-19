#Requires AutoHotkey v2.0

global LStartTime := 0

IsUnrealActive_SelectLine()
{
    hwnd := WinExist("A")

    title := ""
    if hwnd
        title := WinGetTitle(hwnd)

    return WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || InStr(title, "Unreal Editor")
        || WinActive("ahk_class UnrealWindow")
}

#HotIf !IsUnrealActive_SelectLine()

~!LButton::
{
    global LStartTime
    LStartTime := A_TickCount
}

~!LButton Up::
{
    global LStartTime

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    if (holdTime < 250)
    {
        Click
        Sleep 10
        Send "{Home}+{End}"
    }
    else
    {
        ToolTip "드래그/홀드", x + 12, y + 12
        SetTimer () => ToolTip(), -600
    }
}

#HotIf