#Requires AutoHotkey v2.0

HotkeyList := ["^!WheelUp", "^!WheelDown"]

#Requires AutoHotkey v2.0

; ----------------------------------
; 전역 상태 (주석 토글용)
; ----------------------------------
global toggleState := true

; ----------------------------------
; Ctrl + Alt + Wheel Up → 토글 주석
; ----------------------------------
^!WheelUp:: {
    if !WinActive("ahk_exe devenv.exe")
        return  ; VS가 아니면 종료

    ToggleComment()
}

; ----------------------------------
; Ctrl + Alt + Wheel Down → 주석 해제
; ----------------------------------
^!WheelDown:: {
    if !WinActive("ahk_exe devenv.exe")
        return  ; VS가 아니면 종료

    Uncomment()
}

; ----------------------------------
; 주석 토글 함수
; ----------------------------------
ToggleComment() {
    ShowTip("주석 Toggle")
    SendInput("^k^c")  ; VS 단축키: 주석
}

; ----------------------------------
; 주석 해제 함수
; ----------------------------------
Uncomment() {
    ShowTip("주석 해제")
    SendInput("^k^u")  ; VS 단축키: 주석 해제
}

; ----------------------------------
; ToolTip 함수
; ----------------------------------
ShowTip(text) {
    ToolTip text
    SetTimer(() => ToolTip(), -800)  ; 0.8초 후 자동 숨김
}