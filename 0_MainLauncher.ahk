#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; [MAIN LAUNCHER] - 수정 및 최적화 버전
; =========================================================

global MainRunning := false
MainPath := "E:\Programs\MyGits\AutoHotKey\AutoHotKey\0_Main.ahk"

; ---------------------------------------------------------
; ★ [자동 실행 구역] 스크립트 켜지자마자 Main을 바로 실행합니다.
; ---------------------------------------------------------
if FileExist(MainPath) {
    SoundPlay "C:\Windows\Media\notify_Amplified.wav"
    Run MainPath
    global MainRunning := true
    ToolTip "LAUNCHER START: MAIN ON"
    SetTimer () => ToolTip(), -1500
} else {
    MsgBox "메인 스크립트 파일을 찾을 수 없습니다:`n" MainPath, "경로 오류", "Icon!"
}
; ---------------------------------------------------------


; $ 접두사로 무한 루프 방지 및 키보드 훅 사용
$F12::
{
    global MainRunning
    global MainPath

    ; F12 키가 떼어질 때까지 최대 0.4초(400ms) 동안 대기합니다.
    KeyReleased := KeyWait("F12", "T0.4")

    if (KeyReleased)
    {
        ; 1. 짧게 누름 (< 0.4초): 원래 F12 기능 수행
        HotIf
        SetKeyDelay -1
        Send "{Blind}{F12}"
    }
    else
    {
        ; 2. 길게 누름 (≥ 0.4초): MAIN ON / OFF 토글
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
        
        KeyWait "F12"
    }
}