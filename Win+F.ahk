#Requires AutoHotkey v2.0
#SingleInstance Force
; Win + F를 누르고 있는 동안 F11 누른 상태 유지, 디버깅 메시지 포함
LWin & f::
{
    if WinActive("ahk_exe chrome.exe")
    {
        ToolTip "Win+F 눌림 → F12 누름"
        Send "{F11 down}"
        KeyWait "f"
        Send "{F11 up}"
        ToolTip ""
    }
    else
    {
        Send "#f"  ; Win+F 기본 동작 (파일 탐색기 검색)
    }
} 