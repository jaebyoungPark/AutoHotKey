#Requires AutoHotkey v2.0

; ==============================
; Ctrl + Mouse Left
; ==============================
^LButton::
{
    ; Visual Studio가 아니면 원래 기능 유지
    if !WinActive("ahk_exe devenv.exe") {
        Send "^{" "LButton" "}"
        return
    }

    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        Send "{Left}"
    }
    else if (elapsed > 0.20 && elapsed < 0.5) {
        Send "{Left 3}"
    }
}

; ==============================
; Ctrl + Mouse Right
; ==============================
^RButton::
{
    ; Visual Studio가 아니면 원래 기능 유지
    if !WinActive("ahk_exe devenv.exe") {
        Send "^{" "RButton" "}"
        return
    }

    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        Send "{Right}"
    }
    else if (elapsed > 0.20 && elapsed < 0.5) {
        Send "{Right 3}"
    }
}