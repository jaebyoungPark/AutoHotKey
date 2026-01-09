#Requires AutoHotkey v2.0

; ========================================
; Hotkeys
; ========================================

; Alt + 좌클릭

HotKeyList := ["!LButton", "!RButton"]

!LButton::
{
    if WinActive("ahk_exe chrome.exe")
        Send "^+{Tab}"  ; Chrome 전용 Ctrl+Shift+Tab
    else if WinActive("ahk_exe devenv.exe")
        Send "{Home}"   ; Visual Studio 전용 Home
    else
        Send "!{LButton}" ; 기본 동작
}

; Alt + 우클릭
!RButton::
{
    start := A_TickCount
    MouseGetPos &sx, &sy
    isDrag := false

    ; 버튼이 눌려 있는 동안 마우스 이동 감지
    while GetKeyState("RButton", "P")
    {
        Sleep 10
        MouseGetPos &cx, &cy

        if (Abs(cx - sx) > 5 || Abs(cy - sy) > 5)
        {
            isDrag := true
            break
        }

        if ((A_TickCount - start) > 200)
            break
    }

    ; 드래그라면 시스템에 맡김
    if (isDrag)
    {
        Send "{RButton Down}"
        KeyWait "RButton"
        Send "{RButton Up}"
        return
    }

    KeyWait "RButton"
    elapsed := (A_TickCount - start)

    ; Chrome 전용: 짧은 클릭
    if WinActive("ahk_exe chrome.exe")
    {
        if (elapsed < 200)
        {
            Send "^{Tab}"
            return
        }
    }

    ; Visual Studio 전용: End 키
    if WinActive("ahk_exe devenv.exe")
    {
        Send "{End}"
        return
    }

    ; 그 외 환경: 0.2~0.55초 유지 시 Ctrl+Win+.
    if (elapsed >= 200 && elapsed < 550)
    {
        Send "^#."
    }
}