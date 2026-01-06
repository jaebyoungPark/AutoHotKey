#Requires AutoHotkey v2.0

$RButton::
{
    start := A_TickCount
    MouseGetPos &sx, &sy   ; 누른 순간 위치

    isDrag := false

    ; 버튼이 눌려 있는 동안 감시
    while GetKeyState("RButton", "P")
    {
        Sleep 10
        MouseGetPos &cx, &cy

        ; 마우스가 일정 거리 이상 이동하면 드래그 판정
        if (Abs(cx - sx) > 5 || Abs(cy - sy) > 5)
        {
            isDrag := true
            break
        }

        ; 0.2초 넘어가면 루프 탈출
        if ((A_TickCount - start) > 200)
            break
    }

    ; 🔹 드래그면 시스템에 맡김
    if (isDrag)
    {
        Send "{RButton Down}"
        KeyWait "RButton"
        Send "{RButton Up}"
        return
    }

    ; 버튼 떼기까지 대기
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.20)
    {
        ; 기본 우클릭
        Send "{RButton}"
    }
    else if (elapsed < 3.5)
    {
        ; 🔀 mintty(Git Bash) 분기
        if WinActive("ahk_class mintty")
        {
            ; Git Bash 붙여넣기
            Send "+{Insert}"
        }
        else
        {
            ; Ctrl + Win + .
            Send "^#."
        }
    }
}