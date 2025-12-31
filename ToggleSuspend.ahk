^+F11:: {
    global MySuspended, HotkeyList

    start := A_TickCount  ; 누른 시각 기록

    ; Ctrl+Shift+F11이 떼어질 때까지 루프
    while GetKeyState("F11", "P")
        Sleep 10  ; 10ms 간격으로 확인

    elapsed := A_TickCount - start  ; 누른 시간 계산

    if (elapsed >= 250 && elapsed < 600) {  
        MySuspended := !MySuspended

        for key in HotkeyList
            Hotkey(key, "", MySuspended ? "Off" : "On")

        if MySuspended
            SoundBeep(1200,150)
        else
            SoundBeep(800,150)
    }
    else if (elapsed < 250) {
        ; 0.25초 미만으로 짧게 눌렀을 때 Left 키 보내기
        SendInput("{Left}")
    }
}