;----------------------------
; 실제 핫키 정의
;----------------------------

HotkeyList := ["$XButton1"]

$XButton1:: {
    start := A_TickCount
    KeyWait "XButton1"
    elapsed := A_TickCount - start

    if (elapsed < 250) {
        ; 짧게 누름 → 원래 뒤로 가기
        Send "{XButton1}"
    }
    else if (elapsed >= 250 && elapsed < 600) {
        ; 중간 길이 → Ctrl + W
        Send "^w"
    }
    ; 600ms 이상 → 아무 것도 안 함
}

;----------------------------
; 배열에 핫키 이름 등록
;----------------------------
HotkeyList := ["$XButton1"]