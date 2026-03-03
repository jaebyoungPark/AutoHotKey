; =============================
; 전역 변수 초기화
; =============================
global monitor1X := 0, monitor1Y := 0
global monitor2X := 0, monitor2Y := 0

#'::  ; Win + ' 키
{
    MoveMonitorNoGUI()
}
return

MoveMonitorNoGUI() {

    global monitor1X, monitor1Y
    global monitor2X, monitor2Y

    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)

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

    ; =============================
    ; 다음 모니터 결정
    ; =============================
    if currentMonitor = 1 {
        ; 모니터 1 → 2
        monitor1X := mouseX
        monitor1Y := mouseY
        nextMonitor := 2
    } else {
        ; 모니터 2 → 1
        monitor2X := mouseX
        monitor2Y := mouseY
        nextMonitor := 1
    }

    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

    ; =============================
    ; 마우스 이동
    ; =============================
    if nextMonitor = 2 {
        ; 모니터 2 → 항상 중앙
        centerX := nLeft + (nRight - nLeft) / 2
        centerY := nTop + (nBottom - nTop) / 2
        MouseMove(centerX, centerY, 0)
    } else if nextMonitor = 1 {
        ; 모니터 1 → 마지막 저장 위치로 이동
        if monitor1X != 0 && monitor1Y != 0
            MouseMove(monitor1X, monitor1Y, 0)
        else {
            ; 저장된 위치가 없으면 중앙
            centerX := nLeft + (nRight - nLeft) / 2
            centerY := nTop + (nBottom - nTop) / 2
            MouseMove(centerX, centerY, 0)
        }
    }
}