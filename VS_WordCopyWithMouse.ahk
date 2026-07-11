#Requires AutoHotkey v2.0

; [고유 툴팁 함수]
ShowMouseWordTip(msg, t := 500) {
    MouseGetPos &x, &y
    ToolTip "[Debug] " msg, x + 12, y + 12
    SetTimer () => ToolTip(), -t
}

; -----------------------------------------------------------------
; 블렌더가 활성화되어 있을 때는 아래 마우스 핫키들을 아예 무시 (순정 작동)
; -----------------------------------------------------------------
#HotIf !WinActive("ahk_exe blender.exe")

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
            ShowMouseWordTip("단어 ➔ 오른쪽 " MoveCount "칸 이동 (시간: " Round(elapsed, 2) "초)")
            Loop MoveCount
            {
                Send("{Blind}^{Right}")
                Sleep(10)
            }
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            ShowMouseWordTip("개발 환경 아님 ➔ 일반 Ctrl+Shift+우클릭")
            Send("^+{RButton}")
        }
    }
    else
    {
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
            ShowMouseWordTip("단어 ➔ 왼쪽 " MoveCount "칸 이동 (시간: " Round(elapsed, 2) "초)")
            Loop MoveCount
            {
                Send("{Blind}^{Left}")
                Sleep(10)
            }
            if GetKeyState("Ctrl", "P")
                Send("{Ctrl Down}")
        }
        else
        {
            ShowMouseWordTip("개발 환경 아님 ➔ 일반 Ctrl+Shift+좌클릭")
            Send("^+{LButton}")
        }
    }
    else
    {
        ShowMouseWordTip("Ctrl 안 누름 ➔ 일반 Shift+좌클릭 홀드")
        Send("{Blind}{LButton Down}")
        KeyWait("LButton")
        Send("{Blind}{LButton Up}")
    }
} 

#HotIf ; 조건 초기화