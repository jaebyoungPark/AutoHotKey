#Requires AutoHotkey v2.0

global toggleState := true

^!WheelUp::
{
    global toggleState

    if !WinActive("ahk_exe devenv.exe")  ; VS만 작동
        return

    if (toggleState) {
        ShowTip("주석 Toggle : UNCOMMENT (U)")
        SendInput("^k^u")  ; Ctrl+K, Ctrl+U
    } else {
        ShowTip("주석 Toggle : COMMENT (C)")
        SendInput("^k^c")  ; Ctrl+K, Ctrl+C
    }

    toggleState := !toggleState
}

ShowTip(text)
{
    ToolTip text
    SetTimer(() => ToolTip(), -800)  ; 0.8초 후 제거
}