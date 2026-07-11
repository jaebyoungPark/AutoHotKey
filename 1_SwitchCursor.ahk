#Requires AutoHotkey v2.0
#SingleInstance Force

; =============================
; GUI 표시 함수 (마우스 커서 정중앙에 배치)
; =============================
ShowHereGUI() {
    CoordMode("Mouse", "Screen")
    MouseGetPos &x, &y

    border := 6
    boxW   := 220
    boxH   := 80

    guiW := boxW + border*2
    guiH := boxH + border*2

    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Yellow"
    myGui.SetFont("s50 cBlack bold", "Arial")

    myGui.Add("Text", "x" border " y" border " w" boxW " h" boxH " BackgroundRed")
    myGui.Add("Text", "x" border " y" border " w" boxW " h" boxH " Center BackgroundTrans cBlack", "Here")

    myGui.Show("x" . (x - guiW/2) . " y" . (y - guiH/2) . " NoActivate")
    SetTimer () => myGui.Destroy(), -150
}

; =============================
; 핵심: 다음 모니터 정중앙 이동 함수 (이것이 #' 의 실제 기능)
; =============================
MoveToNextMonitorCenter() {
    monitorCount := MonitorGetCount()
    if (monitorCount < 2)
        return

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
    if (currentMonitor = 0)
        return

    nextMonitor := (currentMonitor = 1) ? 2 : 1

    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)
    centerX := Round(nLeft + (nRight - nLeft) / 2)
    centerY := Round(nTop + (nBottom - nTop) / 2)

    CoordMode("Mouse", "Screen")
    MouseMove(centerX, centerY, 0)
}

; =============================
; Win + '  → 단독 모니터 중앙 이동 핫키'''''
; =============================
/*
#':: {
    MoveToNextMonitorCenter()
}
*/
; =============================
; Win + Numpad1 → 모니터 중앙 이동 + GUI 표시
; =============================
#Numpad1:: {
    MoveToNextMonitorCenter()
    Sleep 50 
    ShowHereGUI()
}


; =============================
; Win + Page Down → 모니터 중앙 이동 + GUI 표시
; =============================
#PgDn:: { 
    monitorCount := MonitorGetCount()
    if (monitorCount < 2) {
        ShowHereGUI()
        return
    }
    MoveToNextMonitorCenter()
    Sleep 50
    ShowHereGUI()
}

; =============================
; RButton 핫키 (#' 단축키 전송 버전)
; =============================
$RButton:: {
    start := A_TickCount
    CoordMode("Mouse", "Screen")
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

    ; 우클릭 드래그 시 본래 기능 작동
    if (isDrag) {
        CoordMode("Mouse", "Screen")
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
        ; 👉 함수를 호출하지 않고, 원래 의도하셨던 #' 단축키 입력을 수행합니다!
        SendInput "#'" ;디스플레이퓨전 마우스 커서 위치 설정
        Sleep 50
       
    }
}