#Requires AutoHotkey v2.0

HotKeyList := ["RButton"]

RButton::
{
    local myGui ; ⭐ 함수 가림 방지
    Send "{RButton Down}"
    start := A_TickCount
    MouseGetPos &sx, &sy
    isDrag := false
    
    while GetKeyState("RButton", "P")
    {
        Sleep 10
        MouseGetPos &cx, &cy
        if (Abs(cx - sx) > 2 || Abs(cy - sy) > 2)
        {
            isDrag := true
            break
        }
        if ((A_TickCount - start) > 200)
            break
    }
    
    if (isDrag)
    {
        KeyWait "RButton"
        Send "{RButton Up}"
        return
    }
    
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0
    
    if (elapsed < 0.20)
    {
        Send "{RButton Up}"
    }
    else if (elapsed < 0.55)
    {
        ; ⭐ RButton Down을 취소 (Up 없이 그냥 취소)
        Send "{RButton Up}{Escape}"  ; Escape로 컨텍스트 메뉴 취소
        
        if WinActive("ahk_class mintty")
        {
            Send "+{Insert}"
        }
        else
        {
            Send "^#."
            Sleep 15
            myGui := Gui()
            myGui.SetFont("s48", "Segoe UI Emoji")
            MouseGetPos &mx, &my
            ToolTip "Here I am 😀", mx, my
            Sleep 600
            ToolTip
        }
    }
    else
    {
        Send "{RButton Up}"
    }
}