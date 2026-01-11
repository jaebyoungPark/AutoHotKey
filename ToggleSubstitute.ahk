#Requires AutoHotkey v2

HotkeyList := ["$MButton"]

$MButton:: {
    start := A_TickCount  ; 버튼 누른 시각 기록
    KeyWait("MButton")    ; 버튼 떼기까지 대기

    elapsed := (A_TickCount - start)/1000  ; 누른 시간 계산 (초 단위)

    title := WinGetTitle("A")

    ; ------------------------------
    ; Udemy 환경
    ; ------------------------------
    if InStr(title, "Udemy") {
        if (elapsed >= 0.25 && elapsed <= 0.5) {
            Send "c"
            return
        }
    }
    ; ------------------------------
    ; uTorrent 환경
    ; ------------------------------
    else if WinActive("ahk_exe uTorrent.exe") {
        if (elapsed >= 0.25 && elapsed <= 0.5) {
            Send "N"
            Sleep 50
            Send "E"
 
            return
        }
    }

    ; ------------------------------
    ; 그 외 환경 → 기본 가운데 클릭
    ; ------------------------------
    Click("M")
}