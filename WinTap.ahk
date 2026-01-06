#Requires AutoHotkey v2.0

^+F10:: {
    ; Win 누르고
    Send("{LWin down}")
    Sleep 50  ; 50ms 대기

    ; Tab 누르기
    Send("{Tab}")
    Sleep 50  ; 50ms 대기

    ; Win 떼기
    Send("{LWin up}")
}