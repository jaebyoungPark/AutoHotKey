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

    ; 드래그 감지
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

        ; 🔥 모니터 개수 체크
        monitorCount := MonitorGetCount()

        ; 👉 싱글 모니터면 기존 동작 유지
        if (monitorCount < 2) {
            Send "{RButton}"
            return
        }

        global monitor1X, monitor1Y, monitor2X, monitor2Y

        CoordMode("Mouse", "Screen")
        MouseGetPos &mouseX, &mouseY

        currentMonitor := 0
        Loop monitorCount {
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
}

; =============================
; Win + Page Down
; =============================
#PgDn:: { 
    monitorCount := MonitorGetCount()

    ; 🔥 싱글 모니터면 이동 없이 GUI만 표시
    if (monitorCount < 2) {
        ShowHereGUI()
        return
    }

    SendInput "#'" 
    Sleep 100
    ShowHereGUI()
}