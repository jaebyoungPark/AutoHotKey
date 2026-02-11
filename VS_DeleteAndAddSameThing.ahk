#Requires AutoHotkey v2.0

; ==============================
; Shift + Alt + 0 (Visual Studio 전용)
; ==============================
+!0::   ; Shift + Alt + 0
{
    ; Visual Studio가 아닌 경우 원래 기능 통과
    if !WinActive("ahk_exe devenv.exe") {
        Send "+!0"
        return
    }

    ; Visual Studio 환경에서 Delete 후 ) 입력
    Send "{Delete}"
    Sleep 50
    Send ")"
}

; ==============================
; Shift + Alt + ; (Visual Studio 전용)
; ==============================
+!;::   ; Shift + Alt + ;
{
    ; Visual Studio가 아닌 경우 원래 기능 통과
    if !WinActive("ahk_exe devenv.exe") {
        Send "+!;"
        return
    }

    ; Visual Studio 환경에서 Delete 후 ; 입력
    Send "{Delete}"
    Sleep 50
    Send ";"
}

; ==============================
; Shift + Alt + "  (Visual Studio 전용)
; ==============================
+!'::   ; Shift + Alt + '  → 결과는 "
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "+!'"   ; 원래 동작
        return
    }

    Send "{Delete}"
    Sleep 50
    Send '"'
}