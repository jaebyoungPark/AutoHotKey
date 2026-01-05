#Requires AutoHotkey v2.0

; ==============================
; Ctrl+Alt+P / O 핫키
; ==============================

^!+p:: {
    start := A_TickCount            ; 누르기 시작 시간
    KeyWait "p"                     ; 키를 뗄 때까지 대기
    elapsed := A_TickCount - start  ; 누른 시간(ms)

    ; 유튜브 환경
    if InStr(WinGetTitle("A"), "YouTube") {
        SendInput("+.")   ; 재생속도 올리기
        return
    }
    ; Udemy 환경
    else if InStr(WinGetTitle("A"), "Udemy") {
        SendInput("+{Right}")  ; 재생속도 올리기
        return
    }

    ; ========================================
    ; 비주얼 스튜디오 환경에서만 짧게/중간 길이
    ; ========================================
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            Send "{Right}"              ; 짧게 누르면 오른쪽 방향키
        }
        else if (elapsed >= 250 && elapsed < 550) {
            Send "^!{F12}"             ; 중간 길이 → Ctrl + Alt + F12
        }
        ; 1000ms 이상 → 아무 것도 안 함
    }
}





^!+o:: {
    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; =================
    ; 유튜브 환경
    ; =================
    if InStr(WinGetTitle("A"), "YouTube") {
        SendInput("+,")
        return
    }
    ; =================
    ; Udemy 환경
    ; =================
    else if InStr(WinGetTitle("A"), "Udemy") {
        SendInput("+{Left}")
        return
    }

    ; ========================================
    ; 언리얼 엔진 환경
    ; ========================================
    else if InStr(WinGetTitle("A"), "Unreal Editor") {

        ; 짧게 → 컴파일 + 세이브
        if (elapsed < 200) {
            SendInput("{F7}")     ; Compile
            Sleep 120
            SendInput("^s")       ; Save
        }
        ; 중간 길이 → Shift + F1
        else if (elapsed >= 200 && elapsed < 450) {
            SendInput("+{F1}")    ; Shift + F1
        }
        return
    }

    ; ========================================
    ; 비주얼 스튜디오 환경
    ; ========================================
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            Send "{Left}"
        }
        else if (elapsed >= 250 && elapsed < 550) {
            Send "{F12}"
        }
    }
}