^+F11:: {
    ; =========================
    ; Unreal Engine 환경일 때
    ; =========================
    if WinActive("ahk_exe UnrealEditor.exe") {

        ; --------------------
        ; 디버깅: 처음에 ^^ 표시
        ; --------------------
        ToolTip "^^"
        SetTimer(() => ToolTip(), -200)

        global MySuspended, HotkeyList

        start := A_TickCount

        ; F9이 떼어질 때까지 대기
        while GetKeyState("F11", "P")
            Sleep 10

        elapsed := A_TickCount - start

        if (elapsed >= 200 && elapsed < 800) {
            MySuspended := !MySuspended

            for key in HotkeyList
                Hotkey(key, "", MySuspended ? "Off" : "On")

            ; 🔊 사운드
            if MySuspended
                SoundBeep(1200, 150)
            else
                SoundBeep(800, 150)

            ; 👁️ 상태 표시
            ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
            SetTimer(() => ToolTip(), -800)
        }
        else if (elapsed < 250) {
            SendInput "{Left}"
        }

        return
    }

    ; =========================
    ; 그 외 일반 환경
    ; =========================
    start := A_TickCount

    while GetKeyState("F11", "P")
        Sleep 10

    elapsed := A_TickCount - start

    if (elapsed < 250) {
        SendInput "{Left}"
    }
    else if (elapsed >= 250 && elapsed <= 500) {
        SendInput "^#{/}"
        Sleep 30
        Send "^#."
    }
}