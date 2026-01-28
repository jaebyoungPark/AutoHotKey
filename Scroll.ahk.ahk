#Requires AutoHotkey v2.0

global WheelQueue := 0
global WheelDir := ""
global LastInputTime := 0
global WheelRunning := false
global WheelStack := 0   ; 누적 단계 (6회 단위)

SmoothWheel(dir) {
    global WheelQueue, WheelDir, LastInputTime, WheelRunning, WheelStack

    now := A_TickCount

    if (WheelRunning) {

        if (dir = WheelDir && (now - LastInputTime) <= 300) {
            WheelQueue += 4
            WheelStack++
        }
        else {
            WheelDir := dir
            WheelQueue := 5
            WheelStack := 1
        }

    } else {
        WheelDir := dir
        WheelQueue := 6
        WheelStack := 1
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

        ; ==========================
        ; 💥 초가속 터보 계산식
        ; ==========================
        if (WheelStack <= 2) {
            speed := 8
        }
        else if (WheelStack <= 4) {
            speed := 4
        }
        else if (WheelStack <= 6) {
            speed := 1
        }
        else {
            speed := 0   ; 🔥 터보
        }

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