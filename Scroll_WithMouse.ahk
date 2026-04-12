#Requires AutoHotkey v2.0
global WheelQueue := 0
global WheelDir := ""
global LastInputTime := 0
global WheelRunning := false
global WheelStack := 0

SmoothWheel(dir) {
    global WheelQueue, WheelDir, LastInputTime, WheelRunning, WheelStack
    now := A_TickCount

    if ((now - LastInputTime) <= 300 && dir = WheelDir) {
        WheelQueue += 4
        WheelStack++
    } else {
        WheelDir := dir
        WheelQueue := 2
        WheelStack := 1
    }

    if (!WheelRunning) {
        WheelRunning := true
        SetTimer WheelLoop, 1
    }

    LastInputTime := now
    ToolTip "휠 누적: " WheelStack "단"
}

WheelLoop() {
    global WheelQueue, WheelDir, LastInputTime, WheelRunning, WheelStack
    if (WheelQueue > 0) {
        Click WheelDir
        WheelQueue--
        if (WheelStack <= 2)
            speed := 8
        else if (WheelStack <= 4)
            speed := 4
        else if (WheelStack <= 6)
            speed := 1
        else
            speed := 0
        if (speed > 0)
            Sleep speed
        return
    }
    if ((A_TickCount - LastInputTime) > 300) {
        WheelRunning := false
        WheelStack := 0
        ToolTip
        SetTimer WheelLoop, 0
    }
}

; ==========================
; Hotkeys
; ==========================
!WheelUp:: SmoothWheel("WheelUp")
!WheelDown:: SmoothWheel("WheelDown")