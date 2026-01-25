\::
{
    global MySuspended, HotkeyList
    start := A_TickCount  ; 누른 시각
    while GetKeyState("\", "P")  ; ← \ 하나만! (핫키 컨텍스트 내부)
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
    else
    {
        ; 짧거나 너무 길면 원래 \ 입력
        Send "{\\}"  ; ← 중괄호 포맷 사용!
    }
}