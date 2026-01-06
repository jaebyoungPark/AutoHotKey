^+F11:: {
    start := A_TickCount  ; 누른 시각 기록

    ; F11이 떼어질 때까지 루프
    while GetKeyState("F11", "P")
        Sleep 10  ; 10ms 간격으로 확인

    elapsed := A_TickCount - start  ; 누른 시간 계산

    if (elapsed < 250) {
        ; 짧게 누르면 Left
        SendInput("{Left}")
    }
    else if (elapsed >= 250 && elapsed <= 500) {
        ; 250~500ms → Ctrl + Win + /
        SendInput("^#{/}")  ; ^ = Ctrl, # = Win
    }
}