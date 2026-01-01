;----------------------------
; AHK v2: Ctrl+Shift+A 길게 누름 → Ctrl+Shift+O
;----------------------------



$^+a:: {
    if WinActive("ahk_exe chrome.exe"){

    start := A_TickCount        ; 누른 순간 시간 기록

    KeyWait("Ctrl")             ; Ctrl 떼어질 때까지 대기
    KeyWait("Shift")            ; Shift 떼어질 때까지 대기
    KeyWait("a")                ; A 키 떼어질 때까지 대기

    elapsed := A_TickCount - start

    if (elapsed < 250) {
        ; 짧게 누름 → 원래 Ctrl+Shift+A
        Send("^+a")
    }
    else if (elapsed >= 250 && elapsed < 550) {
        ; 0.5~1초 → Ctrl+Shift+O
        Send("^+o")
    }
    ; 1초 이상 → 아무 것도 안 함
}
}


