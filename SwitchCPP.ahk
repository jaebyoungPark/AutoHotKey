#Requires AutoHotkey v2.0

;--------------------------------
; XButton2 (앞으로 버튼)
; 0.25초 ~ 0.8초 → VS, Chrome, GOM64 처리
;--------------------------------

HotkeyList := ["XButton2"]

XButton2:: {
    start := A_TickCount

    ; 버튼을 뗄 때까지 대기
    KeyWait "XButton2"

    elapsed := A_TickCount - start

    ; 0.25초 이상 0.8초 미만
    if (elapsed >= 250 && elapsed < 800) {

        ; ------------------------------
        ; Visual Studio에서만 실행
        ; ------------------------------
        if WinActive("ahk_exe devenv.exe") {
            SendInput "^k^o"
        }

        ; ------------------------------
        ; Chrome에서만 실행
        ; ------------------------------
        else if WinActive("ahk_exe chrome.exe") {
            Send "f"
        }

        ; ------------------------------
        ; GOM64에서만 실행
        ; ------------------------------
        else if WinActive("ahk_exe GOM64.EXE") {
            Send "{Enter}"
        }
    }
    else {
        ; 그 외 시간 → 기본 앞으로 가기
        Send "{XButton2}"
    }
}