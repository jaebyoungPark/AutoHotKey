#Requires AutoHotkey v2.0

; ======================================
; Win + , 
; ======================================
#,:: 
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        Send "^-"
        return
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe") {
        Send "^+{Tab}"   ; 이전 탭
        return
    }

    ; 그 외 환경 → 완전 차단
    return
}

; ======================================
; Win + .
; ======================================
#.:: 
{
    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        Send "^+-"
        return
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe") {
        Send "^{Tab}"    ; 다음 탭
        return
    }

    ; 그 외 환경 → 완전 차단
    return
}