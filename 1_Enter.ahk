#Requires AutoHotkey v2.0
#SingleInstance Force

enterPressTime := 0
isHolding := false

; ------------------------- 
; 상단 Enter (Win + Enter)
#Enter::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Enter Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; 넘패드 Enter
#NumpadEnter::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#NumpadEnter Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; Win + Numpad0
#Numpad0::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Numpad0 Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; Ctrl + Enter → Ctrl + 클릭
^Enter::
{
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "Enter"
    Send "{LButton Up}{Ctrl Up}"
}

^NumpadEnter::
{
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "NumpadEnter"
    Send "{LButton Up}{Ctrl Up}"
}

; ------------------------- 
; Win + Page Up
#PgUp::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#PgUp Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 250 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; 실제 마우스 클릭 → 홀드 해제
~LButton::
{
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; [원래 상태 복구] Esc → 홀드 중이면 해제
; ------------------------- 
~$Esc::
{
    global isHolding
    
    ; 현재 마우스 드래그 홀드("눌림") 상태라면 해제
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}+Enter::
{
    Send "{LButton}"
    ToolTip "Shift+Enter → Left Click"
    SetTimer () => ToolTip(), -800
}