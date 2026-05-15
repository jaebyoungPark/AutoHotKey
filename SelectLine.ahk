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

; Alt + LButton Down
~!LButton::
{
    global LStartTime

    ; 언리얼 엔진에서는 비활성
    if IsUnrealActive_SelectLine()
        return

    LStartTime := A_TickCount
}

; Alt + LButton Up
~!LButton Up::
{
    global LStartTime

    ; 언리얼 엔진에서는 비활성
    if IsUnrealActive_SelectLine()
        return

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    ; 짧게 클릭 → 현재 줄 선택
    if (holdTime < 250)
    {
        Click
        Sleep 10
        Send "{Home}+{End}"
    }
    ; 길게 누름/드래그 → 원래 Alt 드래그 유지
    else
    {
        ToolTip "드래그/홀드", x + 12, y + 12
        SetTimer () => ToolTip(), -600
    }
}