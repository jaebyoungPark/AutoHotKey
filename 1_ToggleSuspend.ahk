$`::
{
    global MySuspended, HotkeyList
    start := A_TickCount
    while GetKeyState("``", "P")
        Sleep 10
    elapsed := A_TickCount - start
    
    if (elapsed >= 250 && elapsed <= 500)
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
            SoundBeep(1200, 150)
        else
            SoundBeep(800, 150)
        ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
        SetTimer(() => ToolTip(), -800)
    }
    else if (elapsed < 250)
    {
        ; 250ms 미만일 때만 원래 ` 입력
        Send "{``}"
    }
}