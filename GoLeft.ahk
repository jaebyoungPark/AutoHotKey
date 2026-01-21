^+F11:: {
    if WinActive("ahk_exe UnrealEditor.exe") {
        ToolTip "^^"
        SetTimer(() => ToolTip(), -200)
        global MySuspended, HotkeyList
        start := A_TickCount
        
        while GetKeyState("F11", "P")
            Sleep 10
        elapsed := A_TickCount - start
        
        if (elapsed >= 200 && elapsed < 800) {
            MySuspended := !MySuspended
            
            ; 에러 무시하고 토글
            for key in HotkeyList {
                try {
                    Hotkey(key, "", MySuspended ? "Off" : "On")
                } catch {
                    ; 에러 무시
                }
            }
            
            if MySuspended
                SoundBeep(1200, 150)
            else
                SoundBeep(800, 150)
                
            ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
            SetTimer(() => ToolTip(), -800)
        }
        else if (elapsed < 250) {
            SendInput "{Left}"
        }
        return
    }
    
    ; 일반 환경
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