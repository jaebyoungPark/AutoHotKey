#Requires AutoHotkey v2.0

; [고유 툴팁 함수] 다른 스크립트 파일의 툴팁 함수와 충돌하지 않도록 고유하게 선언
ShowMouseWordTip(msg, t := 500) {
    MouseGetPos &x, &y
    ToolTip "[Debug] " msg, x + 12, y + 12
    SetTimer () => ToolTip(), -t
}

; ===================================================================
; Shift + 마우스 오른쪽 또는 Ctrl + Shift + 마우스 오른쪽
; ===================================================================
+RButton::
^+RButton::
{
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        if IsDev()
        {
            start := A_TickCount
            KeyWait("RButton")
            elapsed := (A_TickCount - start) / 1000

            MoveCount := (elapsed < 0.25) ? 1 : 3

            ; [툴팁 추가] 몇 칸 이동하는지와 누른 시간을 표시
            ShowMouseWordTip("단어 ➔ 오른쪽 " MoveCount "칸 이동 (시간: " Round(elapsed, 2) "초)")

            Loop MoveCount
            {
                Send("{Blind}^{Right}")
                Sleep(10)
            }

            ; Ctrl 상태 복구
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            ; [툴팁 추가]
            ShowMouseWordTip("개발 환경 아님 ➔ 일반 Ctrl+Shift+우클릭")
            Send("^+{RButton}")
        }
    }
    else
    {
        ; [툴팁 추가]
        ShowMouseWordTip("Ctrl 안 누름 ➔ 일반 Shift+우클릭 홀드")
        Send("{Blind}{RButton Down}")
        KeyWait("RButton")
        Send("{Blind}{RButton Up}")
    }
}

; ===================================================================
; Shift + 마우스 왼쪽 또는 Ctrl + Shift + 마우스 왼쪽
; ===================================================================
+LButton::
^+LButton::
{
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        if IsDev()
        {
            start := A_TickCount
            KeyWait("LButton")
            elapsed := (A_TickCount - start) / 1000

            MoveCount := (elapsed < 0.25) ? 1 : 3

            ; [툴팁 추가] 몇 칸 이동하는지와 누른 시간을 표시
            ShowMouseWordTip("단어 ➔ 왼쪽 " MoveCount "칸 이동 (시간: " Round(elapsed, 2) "초)")

            Loop MoveCount
            {
                Send("{Blind}^{Left}")
                Sleep(10)
            }

            ; Ctrl 상태 복구
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            ; [툴팁 추가]
            ShowMouseWordTip("개발 환경 아님 ➔ 일반 Ctrl+Shift+좌클릭")
            Send("^+{LButton}")
        }
    }
    else
    {
        ; [툴팁 추가]
        ShowMouseWordTip("Ctrl 안 누름 ➔ 일반 Shift+좌클릭 홀드")
        Send("{Blind}{LButton Down}")
        KeyWait("LButton")
        Send("{Blind}{LButton Up}")
    }
}