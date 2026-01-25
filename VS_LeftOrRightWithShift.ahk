#Requires AutoHotkey v2.0

; ==============================
; Shift + Alt + Mouse Left
; ==============================
+!LButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "+!{LButton}"
        return
    }

    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        Send "+{Left}"
    }
    else if (elapsed > 0.20 && elapsed < 0.5) {
        Send "+{Left 5}"
    }
}

; ==============================
; Shift + Alt + Mouse Right
; ==============================
+!RButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "+!{RButton}"
        return
    }

    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20) {
        Send "+{Right}"
    }
    else if (elapsed > 0.20 && elapsed < 0.5) {
        Send "+{Right 5}"
    }
}

; ==============================
; Alt + Shift + Left
; ==============================
!+Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "!+{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2초 이하 → 기존 동작
    if (elapsed <= 0.20) {
        Send "!+{Left}"
    }
    ; 0.2 ~ 0.6초 → Alt+Shift+Left 5번
    else if (elapsed > 0.20 && elapsed <= 0.6) {
        Loop 5 {
            Send "!+{Left}"
        }
    }
}

; ==============================
; Alt + Shift + Right
; ==============================
!+Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "!+{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2초 이하 → 기존 동작
    if (elapsed <= 0.20) {
        Send "!+{Right}"
    }
    ; 0.2 ~ 0.6초 → Alt+Shift+Right 5번
    else if (elapsed > 0.20 && elapsed <= 0.6) {
        Loop 5 {
            Send "!+{Right}"
        }
    }
}