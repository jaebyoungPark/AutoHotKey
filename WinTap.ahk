;---------------------------------
; Ctrl + Shift + =  → Win + Tab (Task View) 또는 Right
; AHK v2
;---------------------------------

$^+=:: {
    start := A_TickCount  ; 누른 시각 기록

    ; F11처럼 키가 떼어질 때까지 루프
    while GetKeyState("=", "P")
        Sleep 10

    elapsed := A_TickCount - start  ; 누른 시간(ms) 계산

    if (elapsed >= 200 && elapsed < 500) {
        ; 0.4~0.8초 사이 → Win + Tab
        Send("{LWin down}{Tab down}")
        Sleep 50
        Send("{Tab up}{LWin up}")
    }
    else if (elapsed < 250) {
        ; 0.4초 미만 → Right 키
        SendInput("{Right}")
    }
}