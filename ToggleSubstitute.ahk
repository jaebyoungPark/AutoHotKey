#Requires AutoHotkey v2

$MButton::
{
    start := A_TickCount  ; 버튼 누른 시각 기록
    KeyWait("MButton")    ; 버튼 떼기까지 대기

    elapsed := (A_TickCount - start)/1000  ; 누른 시간 계산 (초 단위)

    if InStr(WinGetTitle("A"), "Udemy")
    {
        ; 0.25~0.5초 누름 → C 입력
        if (elapsed >= 0.25 && elapsed <= 0.5)
            Send("c")
    }
    else
    {
        ; Udemy가 아니면 기본 가운데 버튼 클릭
        Click("M")
    }
}
