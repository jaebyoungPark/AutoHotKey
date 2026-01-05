#Requires AutoHotkey v2.0

; ==============================
; 전역 변수
; ==============================
magnifierOn1 := false

; ==============================
; Ctrl+Alt+P 핫키
; ==============================
^!+p:: {
    start := A_TickCount
    KeyWait "p"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; 유튜브 환경
    ; ------------------------------
    if InStr(WinGetTitle("A"), "YouTube") {
        SendInput("+.")   ; 재생속도 올리기
        return
    }

    ; ------------------------------
    ; Udemy 환경
    ; ------------------------------
    else if InStr(WinGetTitle("A"), "Udemy") {
        SendInput("+{Right}")  ; 재생속도 올리기
        return
    }

    ; ------------------------------
    ; 비주얼 스튜디오 환경
    ; ------------------------------
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250)
            Send "{Right}"
        else if (elapsed >= 250 && elapsed < 550)
            Send "^!{F12}"
    }
}

#Requires AutoHotkey v2.0
magnifierOn1 := false

; ==============================
; Ctrl+Alt+O 핫키
; ==============================
^!+o:: {
    global magnifierOn1

    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; Chrome 환경
    ; ------------------------------
    if WinActive("ahk_exe chrome.exe") {

        ; 🔍 돋보기 토글 (200~600ms)
        if (elapsed >= 200 && elapsed < 600) {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1) {
                SendInput("{LWin down}{NumpadAdd}{LWin up}")
                ToolTip "🔍 돋보기 켜짐"
            } else {
                SendInput("{LWin down}{Esc}{LWin up}")
                Sleep 100
                SendInput "{f down}{f up}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }

        ; ------------------------------
        ; 유튜브 (돋보기 조건 외)
        ; ------------------------------
        title := ""
        try {
            title := WinGetTitle("A")
        } catch {
            title := ""
        }

        if InStr(title, "YouTube") {
            SendInput("+,")
            return
        }

        ; ------------------------------
        ; Udemy (돋보기 조건 외)
        ; ------------------------------
        else if InStr(title, "Udemy") {
            SendInput("+{Left}")
            return
        }

        return  ; 그 외 Chrome → 아무 동작 없음
    }

    ; ------------------------------
    ; 언리얼 엔진 환경
    ; ------------------------------
    title := ""
    try {
        title := WinGetTitle("A")
    } catch {
        title := ""
    }

    if InStr(title, "Unreal Editor") {
        if (elapsed < 200) {
            SendInput("{F7}")
            Sleep 120
            SendInput("^s")
        } else if (elapsed >= 200 && elapsed < 450) {
            SendInput("+{F1}")
        }
        return
    }

    ; ------------------------------
    ; 비주얼 스튜디오 환경
    ; ------------------------------
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250)
            Send "{Left}"
        else if (elapsed >= 250 && elapsed < 550)
            Send "{F12}"
    }
}