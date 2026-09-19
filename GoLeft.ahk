#Requires AutoHotkey v2.0
#SingleInstance Force

; 함수 정의 시 소괄호() 필수
HandleTimedHotkey()
{
    start := A_TickCount
    while GetKeyState("F11", "P") ; 주의: F11로 시작했으나 #1 등에서도 호출되므로 GetKeyState 대상을 확인하세요.
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
                ; EnsureWindowActive 함수가 없다면 WinActivate로 대체
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
        SendInput "^#/" ; 디스플레이퓨전 단축키 형식에 맞게 수정 (예: Win+Ctrl+/)
    }
}

; ==============================================================================
; 단축키 구역
; ==============================================================================

^+F11::
{
    HandleTimedHotkey()
}

#1::
{
    ToolTip("DisplayFusion")
    SetTimer(() => ToolTip(), -500)

    SendInput "^#/"
}