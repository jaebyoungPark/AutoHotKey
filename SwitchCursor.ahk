#Requires AutoHotkey v2.0
#SingleInstance Force

; =============================
; 모니터2 좌표 보정 설정 (전역)
; =============================
global mon2OffsetX := 2560
global mon2OffsetY := 4
global mon2ScaleX := 3880.0 / 3660.0
global mon2ScaleY := 811.0 / 677.0

global monitor1X := 0
global monitor1Y := 0
global monitor2X := 0
global monitor2Y := 0

; =============================
; GUI 표시 함수
; =============================
ShowHereGUI() {
    MouseGetPos &x, &y

    border := 6
    boxW   := 220
    boxH   := 80

    guiW := boxW + border*2
    guiH := boxH + border*2

    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Yellow"
    myGui.SetFont("s50 cBlack bold", "Arial")

    myGui.Add("Text"
        , "x" border " y" border
        . " w" boxW " h" boxH
        . " BackgroundRed")

    myGui.Add("Text"
        , "x" border " y" border
        . " w" boxW " h" boxH
        . " Center BackgroundTrans cBlack"
        , "Here")

    myGui.Show("x" . (x - guiW/2) . " y" . (y - guiH/2) . " NoActivate")
    SetTimer () => myGui.Destroy(), -100
}

; =============================
; RButton 핫키
; =============================
$RButton:: { 
    start := A_TickCount 
    MouseGetPos &sx, &sy 
    isDrag := false 
 
    while GetKeyState("RButton", "P") { 
        Sleep 10 
        MouseGetPos &cx, &cy 
        if (Abs(cx - sx) > 4 || Abs(cy - sy) > 4) { 
            isDrag := true 
            break 
        } 
        if ((A_TickCount - start) > 200) 
            break 
    } 
 
    if (isDrag) { 
        Click "Right Down"
        KeyWait "RButton"
        Click "Right Up"
        return 
    } 
 
    KeyWait "RButton" 
    elapsed := (A_TickCount - start) / 1000.0 
 
    if (elapsed < 0.20) { 
        Send "{RButton}" 
    } 
    else if (elapsed < 0.55) { 
        MoveMonitorWithGUI2()
    } 
}

; =============================
; Win + Page Down
; =============================
#PgDn:: { 
    SendInput "#'" 
    Sleep 100
    ShowHereGUI()
}

; =============================
; F2
; =============================
F2:: {
    MoveMonitorWithGUI2()
}

; =============================
; 모니터 이동 + GUI 함수
; =============================
MoveMonitorWithGUI2() {

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

    Sleep 20
    ShowHereGUI()
}





/* 주석처리
; =============================
; RButton (기존 방식 복구)
; =============================
$RButton:: { 
    start := A_TickCount 
    MouseGetPos &sx, &sy 
    isDrag := false 
 
    while GetKeyState("RButton", "P") { 
        Sleep 10 
        MouseGetPos &cx, &cy 
        if (Abs(cx - sx) > 4 || Abs(cy - sy) > 4) { 
            isDrag := true 
            break 
        } 
        if ((A_TickCount - start) > 200) 
            break 
    } 
 
    if (isDrag) { 
        Click "Right Down"
        KeyWait "RButton"
        Click "Right Up"
        return 
    } 
 
    KeyWait "RButton" 
    elapsed := (A_TickCount - start) / 1000.0 
 
    if (elapsed < 0.20) { 
        Send "{RButton}" 
    } 
    else if (elapsed < 0.55) { 
        SendInput "#'"
        Sleep 50
        ShowHereGUI()
    } 
}
*/