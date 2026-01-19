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




#Requires AutoHotkey v2.0

; ==============================
; Alt + Left
; ==============================
!Left::
{
    ; Visual Studio가 아니면 원래 동작 유지
    if !WinActive("ahk_exe devenv.exe") {
        Send "!{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.25초 이하 → 기존 동작
    if (elapsed <= 0.20) {
        Send "!{Left}"
    }
    ; 0.25 ~ 0.5초 → Left 4번
    else if (elapsed > 0.20 && elapsed <= 0.6) {
        Send "{Left 5}"
    }
}

; ==============================
; Alt + Right
; ==============================
!Right::
{
    ; Visual Studio가 아니면 원래 동작 유지
    if !WinActive("ahk_exe devenv.exe") {
        Send "!{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.25초 이하 → 기존 동작
    if (elapsed <= 0.20) {
        Send "!{Right}"
    }
    ; 0.25 ~ 0.5초 → Right 4번
    else if (elapsed > 0.20 && elapsed <= 0.6) {
        Send "{Right 5}"
    }
}