#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; Ctrl + Shift + F11 단축키 구역 (공용 함수 EnsureWindowActive 활용 버전)
; ==============================================================================
^+F11::
{
    start := A_TickCount
    while GetKeyState("F11", "P")
        Sleep 10
    elapsed := A_TickCount - start

    ; [1] 250ms 이하로 짧게 눌렀을 때
    if (elapsed <= 250)
    {
        ; 🎯 [안전장치] 현재 활성화된 창이 아예 없는 순간(찰나의 타이밍) 에러 방지
        if WinExist("A") && WinActive("ahk_exe devenv.exe") ; Visual Studio가 활성화 상태라면
        {
            SendInput "^+f"
            Sleep 100
            SendInput "{Enter}"
        }
        else ; 그 외의 모든 상황 (원하시던 마우스 위치 창 활성화 구역)
        {
            ; 🎯 마우스 커서 아래에 있는 창의 ID(HWND) 획득
            MouseGetPos ,, &mouseHwnd
            
            ; 마우스 아래에 유효한 창이 존재하는지 검사 (바탕화면 허공 등 예외 방지)
            if WinExist("ahk_id " mouseHwnd) 
            {
                ; 🌟 [공용 함수 활용] 마우스 아래 창을 안전하고 확실하게 활성화!
                EnsureWindowActive(mouseHwnd)
                Sleep 50 ; ⚡ 창이 포커스를 완전히 수신할 수 있도록 미세 버퍼 제공
                
                SendInput "{Left}"
            }
            else 
            {
                ; 혹시라도 타겟 창을 못 잡았다면 기본 Left 키 전송
                SendInput "{Left}"
            }
        }
    }
    ; [2] 250ms ~ 1000ms 사이로 길게 눌렀을 때
    else if (elapsed <= 1000)
    {
        SendInput "^#{/}" ;디스플레이퓨전 윈도우 이동 최대화
    }
}