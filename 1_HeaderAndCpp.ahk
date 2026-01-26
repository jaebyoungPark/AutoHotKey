#Requires AutoHotkey v2.0

; Win + End
#End:: {
    if WinActive("ahk_exe devenv.exe") {
        ToolTip "Win+End → VS 감지됨 → F12"
        SetTimer () => ToolTip(), -800
        Send "{F12}"
    } else {
        ToolTip "Win+End → VS 아님 → 원래 동작"
        SetTimer () => ToolTip(), -800
        Send "#End"
    }
}

; Win + Delete
#Delete:: {
    if WinActive("ahk_exe devenv.exe") {
        ToolTip "Win+Del → VS 감지됨 → Ctrl+Alt+F12"
        SetTimer () => ToolTip(), -800
        Send "^!{F12}"
    } else {
        ToolTip "Win+Del → VS 아님 → 원래 동작"
        SetTimer () => ToolTip(), -800
        Send "#Delete"
    }
}