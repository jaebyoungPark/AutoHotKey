#Requires AutoHotkey v2.0
#SingleInstance Force

idleTime := 1200000 ; 20분
warningShown := false

SetTimer(CheckIdle, 1000)

CheckIdle() {
global idleTime, warningShown

; 20분 - 5초 = 19분55초에 경고 표시
if (!warningShown && A_TimeIdle >= idleTime - 5000) {
    warningShown := true
    ShowWarning()
}

; 20분 도달 → 절전
if (A_TimeIdle >= idleTime) {
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
}

; 입력 발생하면 경고 리셋
if (A_TimeIdle < idleTime - 5000) {
    warningShown := false
}

}

ShowWarning() {
myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
myGui.BackColor := "Black"
myGui.SetFont("s20 cWhite bold", "Arial")

myGui.Add("Text", "Center w400 h100", "5초 뒤에 절전모드로 들어갑니다")

; 화면 중앙 표시
myGui.Show("Center NoActivate")

; 5초 후 자동 제거
SetTimer () => myGui.Destroy(), -5000

}