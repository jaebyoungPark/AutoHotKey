#Requires AutoHotkey v2.0
#SingleInstance Force

#Numpad1:: 
{
    SendInput "#'"
    
    Sleep 90
    
    MouseGetPos &x, &y
    
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Yellow"
    myGui.SetFont("s50 cBlack bold", "Arial")  ; 크기 50
    myGui.Add("Text", "BackgroundRed cBlack", "  Here  ")
    myGui.Show("x" . (x - 80) . " y" . (y - 30) . " NoActivate") 
    
    SetTimer () => myGui.Destroy(), -150
}


MoveMonitorWithGUINoGUI() {

    global monitor1X, monitor1Y, monitor2X, monitor2Y
    global mon2OffsetX, mon2OffsetY, mon2ScaleX, mon2ScaleY

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

    if currentMonitor = 1 {
        monitor1X := mouseX
        monitor1Y := mouseY
        nextMonitor := 2
    } else {
        relX := mouseX - mon2OffsetX
        relY := mouseY - mon2OffsetY
        monitor2X := mon2OffsetX + relX * mon2ScaleX
        monitor2Y := mon2OffsetY + relY * mon2ScaleY
        nextMonitor := 1
    }

    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

    if nextMonitor = 1 && monitor1X != 0 {
        MouseMove(monitor1X, monitor1Y, 0)
    } 
    else if nextMonitor = 2 && monitor2X != 0 {
        relX := monitor2X - mon2OffsetX
        relY := monitor2Y - mon2OffsetY
        logX := mon2OffsetX + relX / mon2ScaleX
        logY := mon2OffsetY + relY / mon2ScaleY
        MouseMove(logX, logY, 0)
    } 
    else {
        centerX := nLeft + (nRight - nLeft) / 2
        centerY := nTop + (nBottom - nTop) / 2
        MouseMove(centerX, centerY, 0)
    }

    ; ❌ GUI 표시 제거
}


; =============================
; Win + '  → 모니터 이동만 (GUI 없음)
; =============================
#':: {
    MoveMonitorNoGUI()
}

; =============================
; 모니터 이동 (GUI 없이)
; =============================
MoveMonitorNoGUI() {

    global monitor1X, monitor1Y, monitor2X, monitor2Y
    global mon2OffsetX, mon2OffsetY, mon2ScaleX, mon2ScaleY

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

    if currentMonitor = 1 {
        monitor1X := mouseX
        monitor1Y := mouseY
        nextMonitor := 2
    } else {
        relX := mouseX - mon2OffsetX
        relY := mouseY - mon2OffsetY
        monitor2X := mon2OffsetX + relX * mon2ScaleX
        monitor2Y := mon2OffsetY + relY * mon2ScaleY
        nextMonitor := 1
    }

    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

    if nextMonitor = 1 && monitor1X != 0 {
        MouseMove(monitor1X, monitor1Y, 0)
    } 
    else if nextMonitor = 2 && monitor2X != 0 {
        relX := monitor2X - mon2OffsetX
        relY := monitor2Y - mon2OffsetY
        logX := mon2OffsetX + relX / mon2ScaleX
        logY := mon2OffsetY + relY / mon2ScaleY
        MouseMove(logX, logY, 0)
    } 
    else {
        centerX := nLeft + (nRight - nLeft) / 2
        centerY := nTop + (nBottom - nTop) / 2
        MouseMove(centerX, centerY, 0)
    }

    ; GUI 표시 제거 → Win+'에서는 아무것도 안 그림
}