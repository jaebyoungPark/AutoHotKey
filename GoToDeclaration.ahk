$^!+p:: {
    start := A_TickCount            ; 누르기 시작 시간

    KeyWait "p"                     ; 키를 뗄 때까지 대기

    elapsed := A_TickCount - start  ; 누른 시간(ms)

    if (elapsed < 500) {
        Send "{Right}"              ; 짧게 누르면 오른쪽 방향키
    }
    else if (elapsed >= 500 && elapsed < 1000) {
        Send "^!{F12}"             ; 중간 길이 → Ctrl + Alt + F12
    }
    ; 1000ms 이상 → 아무 것도 안 함
}

; 배열에 핫키 이름 등록
HotkeyList := ["$^!+p"]