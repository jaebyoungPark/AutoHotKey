; --- Alt + Left Arrow ---
!Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ToolTip "Alt+Left (기본 동작)"
        SetTimer () => ToolTip(), -800
        Send "!{Left}"
    }
    else if (elapsed > 0.20 && elapsed <= 0.3) {
        ToolTip "Left 5칸 이동"
        SetTimer () => ToolTip(), -800
        Send "{Left 5}"
    }
    else if (elapsed > 0.3 && elapsed <= 3) {
        ToolTip "Left 10칸 이동"
        SetTimer () => ToolTip(), -800
        Send "{Left 10}"
    }
}

; --- Alt + Right Arrow ---
!Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ToolTip "Alt+Right (기본 동작)"
        SetTimer () => ToolTip(), -800
        Send "!{Right}"
    }
    else if (elapsed > 0.20 && elapsed <= 0.3) {
        ToolTip "Right 5칸 이동"
        SetTimer () => ToolTip(), -800
        Send "{Right 5}"
    }
    else if (elapsed > 0.3 && elapsed <= 3) {
        ToolTip "Right 10칸 이동"
        SetTimer () => ToolTip(), -800
        Send "{Right 10}"
    }
}