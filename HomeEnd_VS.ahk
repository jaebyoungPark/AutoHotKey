#Requires AutoHotkey v2.0

; ==============================
; Ctrl + Mouse Left (Visual Studio only)
; ==============================
^LButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "^{LButton}"
        return
    }

    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ; 기존 Ctrl + 클릭 동작
        Send "^{LButton}"
    }
    else if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{Home}"
    }
}

; ==============================
; Ctrl + Mouse Right (Visual Studio only)
; ==============================
^RButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "^{RButton}"
        return
    }

    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        ; 기존 Ctrl + 클릭 동작
        Send "^{RButton}"
    }
    else if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{End}"
    }
}


#Requires AutoHotkey v2.0

; ==============================
; Ctrl + Left (Visual Studio only)
; ==============================
^Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}^{Left}"
        return
    }

    start := A_TickCount

    ; Left 키가 떼어질 때까지 기다림
    KeyWait "Left"

    elapsed := (A_TickCount - start) / 1000.0

    ; VS 기본 Ctrl+Left 차단
    if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{Home}"
    } else {
        Send "{Blind}^{Left}"
    }
}

; ==============================
; Ctrl + Right (Visual Studio only)
; ==============================
^Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}^{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"

    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{End}"
    } else {
        Send "{Blind}^{Right}"
    }
}