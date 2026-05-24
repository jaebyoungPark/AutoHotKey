#Requires AutoHotkey v2.0

global LStartTime := 0

~!LButton::
{
    global LStartTime

    ; 현재 환경 체크 (inline)
    hwnd := WinExist("A")
    exe := hwnd ? WinGetProcessName(hwnd) : ""

    isTarget :=
        exe = "devenv.exe"
        || exe = "notepad.exe"
        || InStr(WinGetTitle("A"), "Visual Studio")

    ; ❗ 대상 아니면 그냥 종료 (원래 동작 유지)
    if !isTarget
        return

    LStartTime := A_TickCount
}

~!LButton Up::
{
    global LStartTime

    hwnd := WinExist("A")
    exe := hwnd ? WinGetProcessName(hwnd) : ""

    isTarget :=
        exe = "devenv.exe"
        || exe = "notepad.exe"
        || InStr(WinGetTitle("A"), "Visual Studio")

    ; ❗ 대상 아니면 아무것도 안 하고 종료 (기존 Alt 동작 유지)
    if !isTarget
        return

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