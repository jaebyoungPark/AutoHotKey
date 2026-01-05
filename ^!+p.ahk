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
    KeyWait "o"                     ; 키를 뗄 때까지 대기
    elapsed := A_TickCount - start

    ; =================
    ; 유튜브 환경
    ; =================
    if InStr(WinGetTitle("A"), "YouTube") {
        SendInput("+,")   ; 재생속도 내리기
        return
    }
    ; =================
    ; Udemy 환경
    ; =================
    else if InStr(WinGetTitle("A"), "Udemy") {
        SendInput("+{Left}")  ; 재생속도 내리기
        return
    }

    ; ========================================
    ; 언리얼 엔진 환경
    ; ========================================
    else if InStr(WinGetTitle("A"), "Unreal Editor") {
        if (elapsed < 250) {
            SendInput("{F7}")     ; 컴파일
            Sleep 120             ; 컴파일 트리거 안정화
            SendInput("^s")       ; Save
        }
        return
    }

    ; ========================================
    ; 비주얼 스튜디오 환경
    ; ========================================
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            Send "{Left}"               ; 짧게 누르면 왼쪽 방향키
        }
        else if (elapsed >= 250 && elapsed < 550) {
            Send "{F12}"                ; 중간 길이
        }
    }
}