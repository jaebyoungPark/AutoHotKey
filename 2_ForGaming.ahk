global monitor1X := 0
global monitor1Y := 0
global monitor2X := 0
global monitor2Y := 0

F2:: {
       global monitor1X, monitor1Y, monitor2X, monitor2Y  ; <- 전역 변수 선언

    CoordMode("Mouse", "Screen")
    MouseGetPos &mouseX, &mouseY

    currentMonitor := 0
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        if (mouseX >= mLeft && mouseX < mRight && mouseY >= mTop && mouseY < mBottom) {
            currentMonitor := A_Index
            break
        }
    }
    if currentMonitor = 0
        return

    ; 다음 모니터 결정
    if currentMonitor = 1 {
        monitor1X := mouseX
        monitor1Y := mouseY
        nextMonitor := 2
    } else {
        monitor2X := mouseX
        monitor2Y := mouseY
        nextMonitor := 1
    }

    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

    ; 마우스 이동
    if nextMonitor = 2 {
        MouseMove(nLeft + (nRight - nLeft)/2, nTop + (nBottom - nTop)/2, 0)
    } else if nextMonitor = 1 {
        if monitor1X != 0 && monitor1Y != 0
            MouseMove(monitor1X, monitor1Y, 0)
        else
            MouseMove(nLeft + (nRight - nLeft)/2, nTop + (nBottom - nTop)/2, 0)
    }
}


F4:: {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        MsgBox("모니터 " A_Index ": Left=" mLeft " Top=" mTop " Right=" mRight " Bottom=" mBottom)
    }
    
    MsgBox("현재 커서: X=" mouseX " Y=" mouseY)
}
; =========================
; F3 더블클릭 전용
; =========================

~F3:: {
    static lastPressTime := 0
    doubleClickThreshold := 300  ; 300ms

    currentTime := A_TickCount
    timeDiff := currentTime - lastPressTime

    if (timeDiff < doubleClickThreshold) {
        ; ===== 더블클릭 동작 =====
        Send "^#/"   ; Ctrl(^) + Win(#) + /

        lastPressTime := 0
    } else {
        lastPressTime := currentTime
    }
}


; =========================
; Ctrl + Shift + 휠 업 → 볼륨 업
; =========================

^+WheelUp:: {
    Send "{Volume_Up}"
}


; =========================
; Ctrl + Shift + 휠 다운 → 볼륨 다운
; =========================

^+WheelDown:: {
    Send "{Volume_Down}"
}