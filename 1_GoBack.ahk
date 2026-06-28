#Requires AutoHotkey v2.0

ShowCursorTip(msg, t := 400) {
    MouseGetPos &x, &y
    ToolTip msg, x + 12, y + 12
    SetTimer () => ToolTip(), -t
}

; ======================================
; Win + ,  → 뒤로
; ======================================
#,:: 
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        ShowCursorTip "뒤로 (VS)"
        Send "^-"
        return
    }

    ; [추가] VS Code
    if WinActive("ahk_exe code.exe") {
        ShowCursorTip "뒤로 (VSCode)"
        Send "!{Left}"  ; Alt + Left (VS Code 기본 뒤로 가기)
        return
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe") {
        ShowCursorTip "뒤로"
        Send "^+{Tab}"
        return
    }

    ; 그 외 환경 → 차단
    ShowCursorTip "차단됨"
    return
}

; ======================================
; Win + .  → 앞으로
; ======================================
#.:: 
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        ShowCursorTip "앞으로 (VS)"
        Send "^+-"
        return
    }

    ; [추가] VS Code
    if WinActive("ahk_exe code.exe") {
        ShowCursorTip "앞으로 (VSCode)"
        Send "!{Right}" ; Alt + Right (VS Code 기본 앞으로 가기)
        return
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe") {
        ShowCursorTip "앞으로"
        Send "^{Tab}"
        return
    }

    ; 그 외 환경 → 차단
    ShowCursorTip "차단됨"
    return
}

; ======================================
; Win + Numpad4 → 뒤로
; ======================================
#Numpad4::
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        ShowCursorTip "뒤로 (VS)"
        Send "^-"
        return
    }

    ; [추가] VS Code
    if WinActive("ahk_exe code.exe") {
        ShowCursorTip "뒤로 (VSCode)"
        Send "!{Left}"
        return
    }

    ; 그 외 환경 → 기존 동작
    ShowCursorTip "뒤로 (기본)"
    Send "#Numpad4"
}

; ======================================
; Win + Numpad5 → 앞으로
; ======================================
#Numpad5::
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        ShowCursorTip "앞으로 (VS)"
        Send "^+-"
        return
    }

    ; [추가] VS Code
    if WinActive("ahk_exe code.exe") {
        ShowCursorTip "앞으로 (VSCode)"
        Send "!{Right}"
        return
    }

    ; 그 외 환경 → 기존 동작
    ShowCursorTip "앞으로 (기본)"
    Send "#Numpad5"
}