#Requires AutoHotkey v2.0

HotkeyList := ["^!+p", "^!+o"]

; ==============================
; 전역 변수
; ==============================
magnifierOn1 := false

; ==============================
; Ctrl+Alt+Shift+P 핫키
; ==============================
^!+p:: 
{
    start := A_TickCount
    KeyWait "p"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; GOM64 환경
    ; ------------------------------
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "c"  ; 250ms 이하 → C
            return
        }
        ; 필요하면 다른 길이 처리 추가 가능
    }

    ; ------------------------------
    ; 유튜브 환경
    ; ------------------------------
    if InStr(WinGetTitle("A"), "YouTube") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }

    ; ------------------------------
    ; Udemy 환경
    ; ------------------------------
    else if InStr(WinGetTitle("A"), "Udemy") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
        return
    }

    ; ------------------------------
    ; 비주얼 스튜디오 환경
    ; ------------------------------
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            ToolTip "→"
            SetTimer(() => ToolTip(), -600)
            Send "{Right}"
        }
        else if (elapsed >= 250 && elapsed < 550) {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
        }
        return
    }

    ; ------------------------------
    ; 언리얼 엔진 환경
    ; ------------------------------
    CoordMode "Mouse", "Screen"
    if WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") {
        if (elapsed < 200) {
            ToolTip "Escape"
            SetTimer(() => ToolTip(), -700)
            SendInput "+{F1}"
            Sleep 50
            MouseMove 546, 78, 0
        }
        else if (elapsed >= 200 && elapsed < 450) {
            ToolTip "Content Drawer"
            SetTimer(() => ToolTip(), -700)
            Send "^ "
        }
        return
    }
}

; ==============================
; Ctrl+Alt+Shift+O 핫키
; ==============================
^!+o:: 
{
    global magnifierOn1
    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; GOM65 환경
    ; ------------------------------
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "x"  ; 250ms 이하 → X
            return
        }
    }

    ; ------------------------------
    ; Chrome 환경
    ; ------------------------------
    if WinActive("ahk_exe chrome.exe") {
        if (elapsed >= 200 && elapsed < 600) {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1) {
                SendInput "{LWin down}{NumpadAdd}{LWin up}"
                ToolTip "🔍 돋보기 켜짐"
            }
            else {
                SendInput "{LWin down}{Esc}{LWin up}"
                Sleep 100
                SendInput "{f down}{f up}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }

        title := ""
        try title := WinGetTitle("A")
        if InStr(title, "YouTube") {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+,"
            return
        }
        else if InStr(title, "Udemy") {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+{Left}"
            return
        }
    }

    ; ------------------------------
    ; ChatGPT 환경
    ; ------------------------------
    if WinActive("ahk_exe ChatGPT.exe") {
        if (elapsed >= 200 && elapsed < 600) {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1) {
                SendInput "{LWin down}{NumpadAdd}{LWin up}"
                ToolTip "🔍 돋보기 켜짐"
            }
            else {
                SendInput "{LWin down}{Esc}{LWin up}"
                Sleep 100
                SendInput "{f down}{f up}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }
    }

    ; ------------------------------
    ; 언리얼 엔진 환경
    ; ------------------------------
if WinActive("ahk_exe UnrealEditor.exe") {
    if (elapsed < 250) {
        ToolTip "컴파일 후 저장"
        SetTimer(() => ToolTip(), -700)

        SendInput "{F7}"
        Sleep 200
        Send("{Ctrl down}{s down}{s up}{Ctrl up}")
    }

        return
 }

; ------------------------------
; 비주얼 스튜디오 환경
; ------------------------------
if WinActive("ahk_exe devenv.exe") {
    if (elapsed < 250) {
        ; 전체 저장
        Send("^+s")  ; Ctrl + Shift + S → 전체 저장

        ; ToolTip 표시
        ToolTip "전체 저장 완료 😄"
        SetTimer(() => ToolTip(), -1000)  ; 1초 후 자동 숨김
    }
    else if (elapsed >= 250 && elapsed < 550) {
        ToolTip "Def"
        SetTimer(() => ToolTip(), -600)
        Send "{F12}"
    }
}
}