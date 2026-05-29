#Requires AutoHotkey v2.0
#SingleInstance Force

enterPressTime := 0
isHolding := false


; ==================================================
; 넘패드 엔터 (유데미 분기 처리 및 재귀 방지)
; ==================================================
$NumpadEnter::
{
    ; Chrome에서 Udemy 사이트가 활성화되어 있는 경우
    if (WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy"))
    {
        ToolTip "⏸️/▶️ Udemy: Space"
        SetTimer(() => ToolTip(), -700)
        SendInput "{Space}"
    }
    else
    {
        ; 일반 환경에서는 원래의 넘패드 엔터 수행 (Blind로 수정 키 유지)
        SendInput "{Blind}{NumpadEnter}"
    }
}



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

; Esc → 홀드 중이면 해제 / 아니면 원래 Esc 그대로
Esc::
{
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
    else {
        Send "{Esc}"  ; ← 이 부분이 핵심!
    }
}
+Enter::
{
    Send "{LButton}"
    ToolTip "Shift+Enter → Left Click"
    SetTimer () => ToolTip(), -800
}