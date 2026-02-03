$`::
{
    global MySuspended, HotkeyList
    start := A_TickCount
    while GetKeyState("``", "P")
        Sleep 10
    elapsed := A_TickCount - start
    
    if (elapsed >= 250 && elapsed <= 1000)
    {
        MySuspended := !MySuspended
        for key in HotkeyList {
            try {
                Hotkey(key, "", MySuspended ? "Off" : "On")
            } catch {
                ; 무시
            }
        }

if MySuspended
{
    ; 🔒 OFF : 음정 ↓↓
    SoundBeep(1000, 90)
    SoundBeep(700, 90)
}
else
{
    ; 🔓 ON : 음정 ↑↑
    SoundBeep(700, 90)
    SoundBeep(1000, 90)
}

        ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
        SetTimer(() => ToolTip(), -800)
    }
    else if (elapsed < 250)
    {
        ; 250ms 미만일 때만 원래 ` 입력
        Send "{``}"
    }
}