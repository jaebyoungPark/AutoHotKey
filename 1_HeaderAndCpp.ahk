#Requires AutoHotkey v2.0

;f12 자체가 나 헤더와 cpp를 스위칭하므로  Ctrl+Alt+F12 동작하는 키를 넣을 필요가 있는지 진지한 의문이 듦


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

; Win + O → 헤더(.h)
#o:: {
    if WinActive("ahk_exe devenv.exe") {
        ToolTip "Win+O → VS 감지됨 → Header (Ctrl+Alt+F12)"
        SetTimer () => ToolTip(), -800
        Send "^!{F12}"
    } else {
        ToolTip "Win+O → VS 아님 → 원래 동작"
        SetTimer () => ToolTip(), -800
        Send "#o"
    }
}

; Win + P → cpp(.cpp)
#p:: {
    if WinActive("ahk_exe devenv.exe") {
        ToolTip "Win+P → VS 감지됨 → CPP (F12)"
        SetTimer () => ToolTip(), -800
        Send "{F12}"
    } else {
        ToolTip "Win+P → VS 아님 → 원래 동작"
        SetTimer () => ToolTip(), -800
        Send "#p"
    }
}