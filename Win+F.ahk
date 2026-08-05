#Requires AutoHotkey v2.0
#SingleInstance Force

; Chrome 창이 활성화되어 있을 때만 아래 단축키들을 작동시킴
#HotIf WinActive("ahk_exe chrome.exe")

; Win + F (LWin + F) 누르고 있는 동안 F11 유지
#f::
{
    ToolTip "Win+F 눌림 -> F11 Down"
    Send "{F11 down}"
    
    ; f 키를 뗄 때까지 대기
    KeyWait "f"
    
    Send "{F11 up}"
    ToolTip ""
}

#HotIf ; #HotIf 조건 초기화