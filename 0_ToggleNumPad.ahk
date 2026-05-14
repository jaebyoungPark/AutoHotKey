#Requires AutoHotkey v2.0

F10:: {
    global NumPadSuspended, NumPadKeyList
    start := A_TickCount
    while GetKeyState("F10", "P")
        Sleep 10
    elapsed := A_TickCount - start

    if (elapsed >= 250 && elapsed <= 1000) {
        NumPadSuspended := !NumPadSuspended
        for key in NumPadKeyList {
            try {
                Hotkey(key, "", NumPadSuspended ? "Off" : "On")
            } catch {
                ; 무시
            }
        }

        ToolTip(NumPadSuspended ? "🔒 NumPad OFF" : "🔓 NumPad ON")
        SetTimer(() => ToolTip(), -800)

        if NumPadSuspended {
            SoundPlay "C:\Windows\Media\Windows Critical Stop.wav", 1
        } else {
            SoundPlay "C:\Windows\Media\Windows Notify.wav", 1
        }
    } else if (elapsed < 250) {
        Send "{F10}"
    }
}