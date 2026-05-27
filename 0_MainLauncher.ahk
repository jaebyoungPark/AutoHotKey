#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; [MAIN LAUNCHER - 구조 설명]
; =========================================================
; 이 스크립트를 아이콘화하여 실행하면,
; 실제 MAIN 스크립트(0_Main.ahk)가 변경되더라도
; 이 런처 파일(MainLauncher)은 수정/재컴파일/재아이콘화할 필요가 없다.
;
; 즉, "실행 진입점(Launcher)" 역할만 담당하도록 설계된 구조이다.
;
; ---------------------------------------------------------
; [동작 방식]
; ---------------------------------------------------------
; - 짧게 누름 (< 0.4초)
;     → 원래 F12 입력 그대로 전달
;
; - 길게 누름 (≥ 0.4초)
;     → MAIN ON / OFF 토글 실행
;
; ---------------------------------------------------------
; [장점]
; ---------------------------------------------------------
; - MAIN 경로(MainPath)만 수정하면 전체 시스템 유지 가능
; - MAIN 로직 변경 시 Launcher 재빌드 불필요
; - 항상 동일한 실행 진입점 유지
; =========================================================

global MainRunning := false
global Triggered := false

MainPath := "E:\GitProject\AutoHotKey\AutoHotKey\0_Main.ahk"

F12::
{
    global Triggered

    if (Triggered)
        return

    Triggered := true

    ; 0.4초 후 길게 눌렀는지 체크
    SetTimer CheckHold, -400
}

F12 Up::
{
    global Triggered

    ; =========================
    ; 짧게 눌렀을 때 (0.4초 미만)
    ; =========================
    if (Triggered)
    {
        Triggered := false
        Send "{F12}"
    }
}

CheckHold()
{
    global MainRunning
    global Triggered
    global MainPath

    ; =========================
    ; 길게 눌렀을 때만 실행
    ; =========================
    if (Triggered && GetKeyState("F12", "P"))
    {
        ; =========================
        ; OFF -> ON
        ; =========================
        if (!MainRunning)
        {
            SoundPlay "C:\Windows\Media\notify_Amplified.wav"

            Run MainPath
            MainRunning := true

            ToolTip "MAIN ON"
            SetTimer () => ToolTip(), -1200
        }
        ; =========================
        ; ON -> OFF
        ; =========================
        else
        {
            SoundPlay "C:\Windows\Media\Windows Critical Stop_Amplified.wav"

            DetectHiddenWindows true
            SetTitleMatchMode 2

            WinClose "0_Main.ahk ahk_class AutoHotkey"

            MainRunning := false

            ToolTip "MAIN OFF"
            SetTimer () => ToolTip(), -1200
        }
    }

    Triggered := false
}