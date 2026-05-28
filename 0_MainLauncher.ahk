#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; [MAIN LAUNCHER] - 수정 및 최적화 버전
; =========================================================

global MainRunning := false
MainPath := "E:\GitProject\AutoHotKey\AutoHotKey\0_Main.ahk"

; $ 접두사로 무한 루프 방지 및 키보드 훅 사용
$F12::
{
    global MainRunning
    global MainPath

    ; F12 키가 떼어질 때까지 최대 0.4초(400ms) 동안 대기합니다.
    ; T0.4 옵션은 0.4초 안에 키를 떼면 ErrorLevel(0)을, 계속 누르고 있으면 1을 반환합니다.
    KeyReleased := KeyWait("F12", "T0.4")

    if (KeyReleased)
    {
        ; -------------------------------------------------
        ; 1. 짧게 누름 (< 0.4초): 원래 F12 기능 수행
        ; -------------------------------------------------
        ; 핫키를 바이패스하여 본래 기능을 수행하도록 SendLevel을 조정하거나
        ; 가장 안전하게는 핫키를 잠시 끄고(값 전달) 다시 켭니다.
        HotIf
        SetKeyDelay -1
        Send "{Blind}{F12}"  ; {Blind}를 붙여 다른 수식 키와의 혼선을 방지
    }
    else
    {
        ; -------------------------------------------------
        ; 2. 길게 누름 (≥ 0.4초): MAIN ON / OFF 토글
        ; -------------------------------------------------
        if (!MainRunning)
        {
            ; OFF -> ON
            SoundPlay "C:\Windows\Media\notify_Amplified.wav"
            Run MainPath
            MainRunning := true

            ToolTip "MAIN ON"
            SetTimer () => ToolTip(), -1200
        }
        else
        {
            ; ON -> OFF
            SoundPlay "C:\Windows\Media\Windows Critical Stop_Amplified.wav"
            
            DetectHiddenWindows true
            SetTitleMatchMode 2
            WinClose "0_Main.ahk ahk_class AutoHotkey"
            
            MainRunning := false

            ToolTip "MAIN OFF"
            SetTimer () => ToolTip(), -1200
        }
        
        ; 길게 누르고 있는 동안 연속으로 실행되는 것을 방지하기 위해 
        ; 최종적으로 키에서 손을 뗄 때까지 대기합니다.
        KeyWait "F12"
    }
}