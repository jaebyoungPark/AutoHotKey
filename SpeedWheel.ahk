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

        ; 같은 방향 + 0.3초 이내 → 누적
        if (dir = WheelDir && (now - LastInputTime) <= 300) {
            WheelQueue += 6
            WheelStack++
        }
        ; 반대 방향 → 초기화 후 1부터
        else if (dir != WheelDir) {
            WheelDir := dir
            WheelQueue := 6
            WheelStack := 1
        }
        ; 같은 방향이지만 시간 초과 → 새로 시작
        else {
            WheelQueue := 6
            WheelStack := 1
        }

    } else {
        ; 첫 입력
        WheelDir := dir
        WheelQueue := 6
        WheelStack := 1
        WheelRunning := true
        SetTimer WheelLoop, 10
    }

    LastInputTime := now

    ToolTip "휠 누적: " WheelStack "단`n총 휠: " (WheelStack * 6)
}

WheelLoop() {
    global WheelQueue, WheelDir, LastInputTime, WheelRunning, WheelStack

    if (WheelQueue > 0) {
        Click WheelDir
        WheelQueue--

	speed := 15 - (WheelStack - 1) * 5
	if (speed < 1)
  	  speed := 1

        Sleep speed
        return
    }

    ; 입력 끊기면 종료
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