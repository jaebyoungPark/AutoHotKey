#Requires AutoHotkey v2.0

$NumpadDot::
{
    global NumPadSuspended, NumPadKeyList

    start := A_TickCount
    triggered := false

    while GetKeyState("NumpadDot", "P")
    {
        if (!triggered && (A_TickCount - start >= 250))
        {
            triggered := true

            NumPadSuspended := !NumPadSuspended

            for key in NumPadKeyList
            {
                try {
                    Hotkey(key, "", NumPadSuspended ? "Off" : "On")
                } catch {
                    ; 무시
                }
            }

            if NumPadSuspended
                SoundPlay "C:\Windows\Media\Windows Critical Stop.wav"
            else
                SoundPlay "C:\Windows\Media\Windows Notify.wav"
        }

        Sleep 10
    }

    ; 짧게 탭했을 때만 입력
    if (!triggered)
        Send "{NumpadDot}"
}

$F2::
{
    global NumPadSuspended, NumPadKeyList

    start := A_TickCount
    triggered := false

    while GetKeyState("F2", "P")
    {
        if (!triggered && (A_TickCount - start >= 230))
        {
            triggered := true

            NumPadSuspended := !NumPadSuspended

            for key in NumPadKeyList
            {
                try {
                    Hotkey(key, "", NumPadSuspended ? "Off" : "On")
                } catch {
                    ; 무시
                }
            }

            if NumPadSuspended
                SoundPlay "C:\Windows\Media\Windows Critical Stop.wav"
            else
                SoundPlay "C:\Windows\Media\Windows Notify.wav"
        }

        Sleep 10
    }

    ; 짧게 탭했을 때 F2 입력
    if (!triggered)
        Send "{F2}"
}