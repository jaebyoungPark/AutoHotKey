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
; 주석 토글 함수 (Ctrl + /)
; ----------------------------------
ToggleComment() {
    ShowTip("주석 Toggle")
    SendInput "^/"  ; VS 단축키: Ctrl + /
}

; ----------------------------------
; 주석 해제 함수 (Ctrl + /)
; ----------------------------------
Uncomment() {
    ShowTip("주석 해제")
    SendInput "^/"  ; VS 단축키: Ctrl + / (토글이기 때문에 같은 키 사용)
}

; ----------------------------------
; ToolTip 함수
; ----------------------------------
ShowTip(text) {
    ToolTip text
    SetTimer(() => ToolTip(), -800)  ; 0.8초 후 자동 숨김
}