#Requires AutoHotkey v2.0
#SingleInstance Force

; =============================
; 전역 변수 초기화
; =============================
global monitor1X := 0, monitor1Y := 0
global monitor2X := 0, monitor2Y := 0

; =============================
; Win + '  → 모니터 이동 (중앙/복원)
; =============================
#':: {
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
; =============================
; Numpad1 → GUI 표시 + 모니터 이동
; =============================
#Numpad1:: {
    SendInput "#'"  ; 모니터 이동

    Sleep 50  ; 마우스 이동 안정화

    MouseGetPos &x, &y
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Yellow"
    myGui.SetFont("s50 cBlack bold", "Arial")
    myGui.Add("Text", "", "Here")
    myGui.Show("x" . (x - 80) . " y" . (y - 30) . " NoActivate") 

    SetTimer () => myGui.Destroy(), -150
}