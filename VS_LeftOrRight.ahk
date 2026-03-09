; --- Alt + Left Arrow ---
!Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Left}"  ; VS 외에서는 기존 동작
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.2) {
        ; 0.2초 이하 → 5칸 왼쪽 이동
        Send "{Left 5}"
        ToolTip "Left 5칸 이동"
    }
    else {
        ; 0.2초 초과 → 기존 Alt+Left
        Send "!{Left}"
        ToolTip "Alt+Left (기본 동작)"
    }

    ; 0.8초 후에 툴팁 제거
    SetTimer () => ToolTip(), -800
    return
}

; --- Alt + Right Arrow ---
!Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Right}"  ; VS 외에서는 기존 동작
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.2) {
        ; 0.2초 이하 → 5칸 오른쪽 이동
        Send "{Right 5}"
        ToolTip "Right 5칸 이동"
    }
    else {
        ; 0.2초 초과 → 기존 Alt+Right
        Send "!{Right}"
        ToolTip "Alt+Right (기본 동작)"
    }

    ; 0.8초 후에 툴팁 제거
    SetTimer () => ToolTip(), -800
    return
}