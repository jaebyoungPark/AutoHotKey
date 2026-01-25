#Requires AutoHotkey v2.0
#SingleInstance Force

winDownTime := 0

; Win 키 누름
~LWin::
{
    global winDownTime
    winDownTime := A_TickCount
}

; Win 키 뗌
~LWin Up::
{
    global winDownTime

    holdTime := A_TickCount - winDownTime

    if (holdTime < 300) {
        ; 0.5초 미만 → 기존 Win 기능 패스
        Send "{Blind}{LWin}"
    }
    ; 0.5초 이상이면 아무것도 안 함 (차단)
}