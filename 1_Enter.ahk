#Requires AutoHotkey v2.0

enterPressTime := 0
isHolding := false

; -------------------------
; 상단 Enter (Win + Enter)
#Enter:: {
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Enter Up:: {
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    if (holdDuration >= 400 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    } else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; -------------------------
; 넘패드 Enter (Win + NumpadEnter)
#NumpadEnter:: {
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#NumpadEnter Up:: {
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    if (holdDuration >= 400 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    } else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; -------------------------
; Win + Numpad1 (Win + Enter와 동일)
#Numpad0:: {
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Numpad0 Up:: {
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    if (holdDuration >= 400 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    } else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; -------------------------
; Ctrl + Enter → Ctrl + 마우스 왼클릭
^Enter:: {
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "Enter"
    Send "{LButton Up}{Ctrl Up}"
}

^NumpadEnter:: {
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "NumpadEnter"
    Send "{LButton Up}{Ctrl Up}"
}

; -------------------------
; Win + Page Up
#PgUp:: {
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#PgUp Up:: {
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    if (holdDuration >= 250 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    } else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; -------------------------
; 실제 마우스 클릭 시 홀드 해제
~LButton:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; Esc로도 홀드 해제
~Esc:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}