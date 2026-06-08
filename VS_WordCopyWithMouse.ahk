#Requires AutoHotkey v2.0

; ===================================================================
; Shift + 마우스 오른쪽 또는 Ctrl + Shift + 마우스 오른쪽
; ===================================================================
+RButton::
^+RButton::
{
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        if WinActive("ahk_exe devenv.exe")
        {
            start := A_TickCount
            KeyWait("RButton")
            elapsed := (A_TickCount - start) / 1000

            MoveCount := (elapsed < 0.25) ? 1 : 3

            Loop MoveCount
            {
                Send("{Blind}^{Right}")
                Sleep(10)
            }

            ; Ctrl 상태 복구
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            Send("^+{RButton}")
        }
    }
    else
    {
        Send("{Blind}{RButton Down}")
        KeyWait("RButton")
        Send("{Blind}{RButton Up}")
    }
}

; ===================================================================
; Shift + 마우스 왼쪽 또는 Ctrl + Shift + 마우스 왼쪽
; ===================================================================
+LButton::
^+LButton::
{
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        if WinActive("ahk_exe devenv.exe")
        {
            start := A_TickCount
            KeyWait("LButton")
            elapsed := (A_TickCount - start) / 1000

            MoveCount := (elapsed < 0.25) ? 1 : 3

            Loop MoveCount
            {
                Send("{Blind}^{Left}")
                Sleep(10)
            }

            ; Ctrl 상태 복구
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            Send("^+{LButton}")
        }
    }
    else
    {
        Send("{Blind}{LButton Down}")
        KeyWait("LButton")
        Send("{Blind}{LButton Up}")
    }
}