#Requires AutoHotkey v2.0

^u::
{
    start := A_TickCount
    KeyWait "u"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2초 이하 → 항상 기존 Ctrl+U
    if (elapsed <= 0.2)
    {
        Send "^u"
        return
    }

    ; 0.2 ~ 0.55초
    if (elapsed <= 0.55)
    {
        if WinActive("ahk_exe devenv.exe")
        {
            SendText "UPROPERTY(EditAnywhereCategory=)"
            Loop 10
                Send "{Left}"
        }
        else
        {
            Send "^u"
        }
        return
    }

    ; 0.55초 초과 → 기존 Ctrl+U
    Send "^u"
}