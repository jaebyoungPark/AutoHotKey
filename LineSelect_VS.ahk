#Requires AutoHotkey v2.0

; ==============================
; Ctrl + Shift + Left
; ==============================
^+Left::
{
    ; Visual Studio 아니면 기존 동작
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}^+{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed > 0.20 && elapsed <= 0.60) {
        ; 선택한 채 줄 시작
        Send "+{Home}"
    } else {
        ; 기존 Ctrl + Shift + Left
        Send "{Blind}^+{Left}"
    }
}

; ==============================
; Ctrl + Shift + Right
; ==============================
^+Right::
{
    ; Visual Studio 아니면 기존 동작
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}^+{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed > 0.20 && elapsed <= 0.60) {
        ; 선택한 채 줄 끝
        Send "+{End}"
    } else {
        ; 기존 Ctrl + Shift + Right
        Send "{Blind}^+{Right}"
    }
}