#Requires AutoHotkey v2.0

global LStartTime := 0

~!LButton::
{
    global LStartTime

    hwnd := WinExist("A")

    ; 활성 창 없으면 종료
    if !hwnd
        return

    exe   := WinGetProcessName(hwnd)
    title := WinGetTitle(hwnd)

    isTarget :=
           exe = "devenv.exe"
        || exe = "notepad.exe"
        || InStr(title, "Visual Studio")

    ; 대상 아니면 종료
    if !isTarget
        return

    LStartTime := A_TickCount
}

~!LButton Up::
{
    global LStartTime

    hwnd := WinExist("A")

    ; 활성 창 없으면 종료
    if !hwnd
        return

    exe   := WinGetProcessName(hwnd)
    title := WinGetTitle(hwnd)

    isTarget :=
           exe = "devenv.exe"
        || exe = "notepad.exe"
        || InStr(title, "Visual Studio")

    ; 대상 아니면 종료
    if !isTarget
        return

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    ; 짧게 클릭
    if (holdTime < 250)
    {
        Click

        Sleep 10

        Send "{Home}+{End}"
    }
    else
    {
        ; 길게 누름
        ToolTip "드래그/홀드", x + 12, y + 12
        SetTimer () => ToolTip(), -600
    }
}