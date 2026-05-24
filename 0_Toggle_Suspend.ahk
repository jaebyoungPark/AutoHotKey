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

        ; ✅ 1. 먼저 문구 출력
        ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
        SetTimer(() => ToolTip(), -800)

        ; ✅ 2. 그 다음 사운드
        if MySuspended
        {
            SoundPlay "C:\Windows\Media\Windows Critical Stop_Amplified.wav", 1
        }
        else
        {
            SoundPlay "C:\Windows\Media\notify_Amplified.wav", 1
        }
    }
    else if (elapsed < 250)
    {
        Send "{``}"
    }
}