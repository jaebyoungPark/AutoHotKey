#Requires AutoHotkey v2.0

; ===================================================
; 🖱️ Alt + Mouse + Arrow 단축키 (Visual Studio 전용)
; ===================================================

; --- Alt + Left Mouse ---
!LButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{LButton}"  ; Alt 상태 유지하면서 원래 클릭 전달
        return
    }

    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20)
        Send "{Left}"
    else if (elapsed > 0.20 && elapsed < 0.5)
        Send "{Left 3}"
}

; --- Alt + Right Mouse ---
!RButton::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{RButton}"
        return
    }

    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20)
        Send "{Right}"
    else if (elapsed > 0.20 && elapsed < 0.5)
        Send "{Right 3}"
}

; --- Alt + Left Arrow ---
!Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Left}"  ; OS 스루
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20)
        Send "!{Left}"
    else if (elapsed > 0.20 && elapsed <= 0.6)
        Send "{Left 5}"
}

; --- Alt + Right Arrow ---
!Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.20)
        Send "!{Right}"
    else if (elapsed > 0.20 && elapsed <= 0.6)
        Send "{Right 5}"
}