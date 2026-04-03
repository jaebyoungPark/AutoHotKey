#Requires AutoHotkey v2.0

global LStartTime := 0

; Alt + LButton Down
~!LButton::
{
    global LStartTime
    LStartTime := A_TickCount
}

; Alt + LButton Up
~!LButton Up::
{
    global LStartTime

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    ; 0.2초 미만 → 줄 선택
    if (holdTime < 250)
    {
 	Click
	Sleep 10
	Send "{Home}+{End}"

    }
    else
    {
        ; 0.2초 이상 → 홀드
        ToolTip "드래그/홀드", x + 12, y + 12
        SetTimer () => ToolTip(), -600
    }
}