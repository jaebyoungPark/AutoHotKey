;--------------------------------
; XButton2 (앞으로 버튼)
; 0.4초 ~ 1초 → VS Ctrl+K, Ctrl+O
;--------------------------------

HotkeyList := ["$XButton2"]

$XButton2:: {
    start := A_TickCount

    ; 버튼을 뗄 때까지 대기
    KeyWait "XButton2"

    elapsed := A_TickCount - start

    ; 0.4초 이상 1초 미만
    if (elapsed >= 250 && elapsed < 800) {

        ; Visual Studio에서만 실행
        if WinActive("ahk_exe devenv.exe") {

            ; Ctrl+K
            Send("^k")
            Sleep 30

            ; Ctrl 누른 상태에서 O
            Send("^o")
        }

        ; Chrome에서만 실행
        if WinActive("ahk_exe chrome.exe") {

            Send("f")
        }
    }
    else {
        ; 그 외 시간 → 기본 앞으로 가기
        Send("{XButton2}")
    }
}