#Requires AutoHotkey v2.0

; [고유 툴팁 함수] 다른 파일의 툴팁 함수와 충돌하지 않도록 고유하게 선언
ShowKeyWordTip(msg, t := 500) {
    MouseGetPos &x, &y
    ToolTip "[Debug] " msg, x + 12, y + 12
    SetTimer () => ToolTip(), -t
}

; ==============================
; Ctrl + Shift + Left
; ==============================
^+Left::
{
    ; Visual Studio 아니면 기존 동작
    if !WinActive("ahk_exe devenv.exe") {
        ShowKeyWordTip("VS 아님 ➔ 일반 Ctrl+Shift+Left", 600)
        Send "{Blind}^+{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed > 0.20 && elapsed <= 0.60) {
        ; 선택한 채 줄 시작
        ShowKeyWordTip("줄 시작 선택 (+Home) ➔ 시간: " Round(elapsed, 2) "초")
        Send "+{Home}"
    } else {
        ; 기존 Ctrl + Shift + Left
        ShowKeyWordTip("단어 왼쪽 선택 (^+Left) ➔ 시간: " Round(elapsed, 2) "초")
        Send "{Blind}^+{Left}"
    }
}

; ==============================
; Ctrl + Shift + Right
; ==============================
^+Right::
{
    ; Visual Studio 아니면 기존 동작
    if !WinActive("ahk_exe devenv.exe") {
        ShowKeyWordTip("VS 아님 ➔ 일반 Ctrl+Shift+Right", 600)
        Send "{Blind}^+{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed > 0.20 && elapsed <= 0.60) {
        ; 선택한 채 줄 끝
        ShowKeyWordTip("줄 끝 선택 (+End) ➔ 시간: " Round(elapsed, 2) "초")
        Send "+{End}"
    } else {
        ; 기존 Ctrl + Shift + Right
        ShowKeyWordTip("단어 오른쪽 선택 (^+Right) ➔ 시간: " Round(elapsed, 2) "초")
        Send "{Blind}^+{Right}"
    }
}