; =====================================================
;  모니터 + 본체 절전 스크립트 (AutoHotkey v2)
;  마지막 입력 후 15초 동안 아무것도 안 하면:
;    → 5초 카운트다운 UI 표시 (10초 경과 시점)
;    → 모니터 절전 (15초 경과 시점)
;    → 2초 후 본체 절전
;  절전 해제 후 입력 감지되면 다시 타이머 시작
; =====================================================

#Requires AutoHotkey v2.0

global countdown := 5
global txtCount := ""
global gCountdown := ""
global uiVisible := false
global sleeping := false

; 1초마다 유휴 시간 체크
SetTimer(CheckIdle, 1000)

CheckIdle() {
    global uiVisible, sleeping

    idleSec := Floor(A_TimeIdlePhysical / 1000)

    ; 절전 해제 직후 감지
    if (sleeping && idleSec < 2) {
        ResetAll()
        return
    }

    ; 19분 55초 경과 → 5초 카운트다운 시작
    if (!uiVisible && !sleeping && idleSec >= 1195) {
        ShowCountdownUI()
        return
    }

    ; 입력 감지 → 카운트다운 취소
    if (uiVisible && idleSec < 1) {
        ResetAll()
        return
    }
}

ShowCountdownUI() {
    global gCountdown, txtCount, uiVisible, countdown

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
    global countdown, txtCount, gCountdown, sleeping

    countdown -= 1

    if (countdown <= 0) {
        SetTimer(UpdateCountdown, 0)
        sleeping := true
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
