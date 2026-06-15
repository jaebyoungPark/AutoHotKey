#Requires AutoHotkey v2.0
#SingleInstance Force

global countdown := 5
global txtCount := ""
global gCountdown := ""
global uiVisible := false
global sleeping := false

; ⚡ [추가] 실제 절전 진입 순간의 마우스 좌표를 기록할 전역 변수
global EndMouseX := 0
global EndMouseY := 0

; 1초마다 유휴 시간 체크
SetTimer(CheckIdle, 1000)

CheckIdle() {
    global uiVisible, sleeping, StartMouseX, StartMouseY, EndMouseX, EndMouseY

    idleSec := Floor(A_TimeIdlePhysical / 1000)

    ; 🎯 [수정] 진짜 절전 모드(모니터 꺼짐) 상태에서 깨어날 때의 조건
    if (sleeping) {
        if (idleSec < 2) {
            CoordMode "Mouse", "Screen"
            MouseGetPos &NowX, &NowY
            
            ; 절전 진입 시점(EndMouse)과의 직선 거리 계산
            dist := Sqrt((NowX - EndMouseX)**2 + (NowY - EndMouseY)**2)
            
            ; ⚡ 150픽셀 이상 크게 움직여야만 완전히 해제하고 다시 유휴 체크 시작
            if (dist >= 150) {
                ResetAll()
            }
            return
        }
    }

    ; 4분 55초 경과 → 5초 카운트다운 시작
    if (!uiVisible && !sleeping && idleSec >= 495) {
        ShowCountdownUI()
        return
    }

    ; [카운트다운 UI 표시 중] 마우스/키보드 입력 감지 시 처리
    if (uiVisible) {
        ; 키보드나 마우스 입력이 감지되어 유휴 시간이 초기화되었을 때
        if (idleSec < 1) {
            CoordMode "Mouse", "Screen"
            MouseGetPos &NowX, &NowY

            dx := Abs(NowX - StartMouseX)
            dy := Abs(NowY - StartMouseY)

            ; 1. 마우스가 500픽셀 이상 움직였거나
            ; 2. 마우스는 안 움직였는데 idleSec가 줄었다면 (즉, 키보드를 눌렀다면) 취소
            if (dx > 500 || dy > 500 || (dx == 0 && dy == 0)) {
                ResetAll()
                return
            }
        }
    }
}

ShowCountdownUI() {
    global gCountdown, txtCount, uiVisible, countdown
    global StartMouseX, StartMouseY

    CoordMode "Mouse", "Screen"
    MouseGetPos(&StartMouseX, &StartMouseY)

    uiVisible := true
    countdown := 5

    gCountdown := Gui("+AlwaysOnTop -Caption +ToolWindow", "절전 예고")
    gCountdown.BackColor := "0A0A0F"
    WinSetTransparent(220, gCountdown)

    gCountdown.SetFont("s28 cFF4444 Bold", "Segoe UI")
    gCountdown.Add("Text", "x0 y18 w420 Center", "⚡ 절전 모드 전환 예고")

    gCountdown.SetFont("s11 c888899", "Segoe UI")
    gCountdown.Add("Text", "x0 y60 w420 Center", "잠시 후 모든 모니터가 절전됩니다")

    gCountdown.SetFont("s72 cFFFFFF Bold", "Segoe UI")
    txtCount := gCountdown.Add("Text", "x0 y85 w420 Center", "5")

    gCountdown.SetFont("s10 c666677", "Segoe UI")
    gCountdown.Add("Text", "x0 y195 w420 Center", "모니터 절전 후 2초 뒤 본체도 절전됩니다")

    gCountdown.SetFont("s10 cCCCCCC", "Segoe UI")
    btnCancel := gCountdown.Add("Button", "x160 y225 w100 h28", "취소 (ESC)")
    btnCancel.OnEvent("Click", (*) => ResetAll())

    gCountdown.Show("w420 h268 Center")
    HotKey("Escape", (*) => ResetAll())

    SetTimer(UpdateCountdown, 1000)
}

UpdateCountdown() {
    global countdown, txtCount, gCountdown, sleeping, EndMouseX, EndMouseY

    countdown -= 1

    if (countdown <= 0) {
        SetTimer(UpdateCountdown, 0)
        sleeping := true
        
        ; 🎯 [추가] 모니터가 꺼지기 직전 최종 마우스 위치를 기억합니다.
        CoordMode "Mouse", "Screen"
        MouseGetPos &EndMouseX, &EndMouseY
        
        try gCountdown.Destroy()

        ; 모니터 절전
        SendMessage(0x0112, 0xF170, 2, , "Program Manager")

        ; 2초 후 본체 절전
        SetTimer(SleepPC, -2000)
        return
    }

    if (countdown <= 2)
        txtCount.SetFont("cFF2222")
    else if (countdown <= 3)
        txtCount.SetFont("cFF8800")

    txtCount.Value := countdown
}

SleepPC() {
    DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

ResetAll() {
    global uiVisible, sleeping, gCountdown, countdown

    SetTimer(UpdateCountdown, 0)
    SetTimer(SleepPC, 0)
    uiVisible := false
    sleeping := false
    countdown := 5
    try HotKey("Escape", "Off")
    try gCountdown.Destroy()
}