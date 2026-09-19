#Requires AutoHotkey v2.0
#SingleInstance Force

; 함수에 확인할 키 이름을 인자로 받도록 수정
HandleTimedHotkey(keyName)
{
    start := A_TickCount
    while GetKeyState(keyName, "P")
        Sleep 10
    
    elapsed := A_TickCount - start
    
    ; [1] 250ms 이하로 짧게 눌렀을 때
    if (elapsed <= 250)
    {
        if WinExist("A") && WinActive("ahk_exe devenv.exe")
        {
            SendInput "^+f"
            Sleep 100
            SendInput "{Enter}"
        }
        else 
        {
            MouseGetPos ,, &mouseHwnd
            
            if WinExist("ahk_id " mouseHwnd) 
            {
                WinActivate("ahk_id " mouseHwnd)
                Sleep 50 
                SendInput "{Left}"
            }
            else 
            {
                SendInput "{Left}"
            }
        }
    }
    ; [2] 250ms ~ 1000ms 사이로 길게 눌렀을 때
    else if (elapsed <= 1000)
    {
        SendInput "^#/"
    }
}

; ==============================================================================
; 단축키 구역
; ==============================================================================
^+F11::
{
    HandleTimedHotkey("F11")
}

#1::
{
    HandleTimedHotkey("1")
}