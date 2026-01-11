#Requires AutoHotkey v2.0

HotkeyList := ["$XButton1"]

$XButton1:: {
    start := A_TickCount

    ; 최대 0.5초까지만 기다림
    if !KeyWait("XButton1", "T0.5") {
        ; ⏱ 500ms 초과 → 즉시 End 표시 후 종료
        ToolTip "End"
        SetTimer () => ToolTip(), -600
        return
    }

    elapsed := A_TickCount - start

    if (elapsed < 250) {
        ; 짧게 누름 → 원래 뒤로 가기
        Send "{XButton1}"
    }
    else {
        ; 250 ~ 500ms
        if WinActive("ahk_exe GOM64.EXE") {
            Send "!{F4}"
        } else {
            Send "^w"
        }
    }
}