#Requires AutoHotkey v2.0

global LStartTime := 0

; Alt + LButton Down
~!LButton::
{
    global LStartTime

    if WinActive("ahk_exe devenv.exe")
    {
        LStartTime := A_TickCount
    }
}

; Alt + LButton Up
~!LButton Up::
{
    global LStartTime

    ; Visual Studio 아닐 경우 → 아무것도 안 하고 기본 동작만 수행
    if !WinActive("ahk_exe devenv.exe")
        return

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    ; 0.25초 미만 → 줄 선택
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