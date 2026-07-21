#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; [ 설정 영역 ] - 이 영역의 값만 수정하여 동작을 조절하세요!
; ============================================================
global CFG_DRAG_THRESHOLD := 20   ; 드래그 판정 임계값 (픽셀 단위, 손떨림 방지용. 기본: 10)
global CFG_HOLD_MIN       := 0.20 ; 모니터 이동 인정 최소 누름 시간 (초)
global CFG_HOLD_MAX       := 0.55 ; 모니터 이동 인정 최대 누름 시간 (초)
global CFG_USE_DISPLAYFUSION := true ; true: DisplayFusion 단축키(Win+') 전송 / false: 순수 AHK 함수 사용

; ============================================================
; GUI 표시 함수 (마우스 커서 정중앙에 배치)
; ============================================================
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

; ============================================================
; 다음 모니터 정중앙 이동 함수
; ============================================================
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

; ============================================================
; 모니터 이동 실행 함수
; ============================================================
ExecuteMonitorSwitch() {
    if (CFG_USE_DISPLAYFUSION) {
        SendInput "#'" ; DisplayFusion 단축키 전송
        Sleep 50
    } else {
        MoveToNextMonitorCenter()
        Sleep 50
        ShowHereGUI()
    }
}

; ============================================================
; 우클릭 드래그 감지 처리 함수
; ============================================================
ProcessRightClick() {
    start := A_TickCount
    CoordMode("Mouse", "Screen")
    MouseGetPos &sx, &sy
    isDrag := false

    ; 드래그 감지 루프
    while GetKeyState("RButton", "P") {
        Sleep 10
        MouseGetPos &cx, &cy
        
        ; 설정된 임계값(CFG_DRAG_THRESHOLD)보다 많이 움직였는지 검사
        if (Abs(cx - sx) > CFG_DRAG_THRESHOLD || Abs(cy - sy) > CFG_DRAG_THRESHOLD) {
            isDrag := true
            break
        }
        
        ; 드래그 판단 시간(200ms) 초과 시 감지 종료
        if ((A_TickCount - start) > 200)
            break
    }

    ; 1. 실제 드래그 발생 시 -> 일반 우클릭 드래그 수행
    if (isDrag) {
        CoordMode("Mouse", "Screen")
        Click "Right Down"
        KeyWait "RButton"
        Click "Right Up"
        return
    }

    ; 버튼을 뗄 때까지 대기 및 누른 시간 측정
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    ; 2. 짧게 클릭 시 -> 일반 우클릭
    if (elapsed < CFG_HOLD_MIN) {
        Send "{RButton}"
    }
    ; 3. 지정한 시간 동안 누르고 있다가 뗀 경우 -> 모니터 이동
    else if (elapsed >= CFG_HOLD_MIN && elapsed <= CFG_HOLD_MAX) {
        ExecuteMonitorSwitch()
    }
}

; ============================================================
; 핫키 설정
; ============================================================
$RButton::ProcessRightClick()

#Numpad1:: {
    MoveToNextMonitorCenter()
    Sleep 50 
    ShowHereGUI()
}

#PgDn:: { 
    if (MonitorGetCount() < 2) {
        ShowHereGUI()
        return
    }
    MoveToNextMonitorCenter()
    Sleep 50
    ShowHereGUI()
}