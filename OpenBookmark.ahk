;----------------------------
; AHK v2: Ctrl+Shift+A 길게 누름 → Ctrl+B
;----------------------------
$^+a:: {
    if WinActive("ahk_exe chrome.exe"){
        start := A_TickCount        ; 누른 순간 시간 기록
        KeyWait("a")                ; A 키만 떼어질 때까지 대기
        elapsed := A_TickCount - start
        
        if (elapsed < 250) {
            ; 짧게 누름 → 원래 Ctrl+Shift+A
            Send("^+a")
        }
        else if (elapsed >= 250 && elapsed < 550) {
            ; 0.25~0.55초 → Ctrl+B
            Send("^b")
        }
        ; 0.55초 이상 → 아무 것도 안 함
    }
}