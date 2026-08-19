#Requires AutoHotkey v2.0

; [디버깅 함수] 문구를 전달받아 마우스 위치에 0.5초간 툴팁 출력
DebugRightCtrlMsg(msg)
{
    ToolTip(msg)
    SetTimer () => ToolTip(), -500
}

; Right Control(SC11D) 키가 눌려있는 동안 적용
#HotIf GetKeyState("SC11D", "P")

.:: 
{
    DebugRightCtrlMsg("NumpadDel 입력됨")
    Send "{NumpadDel}"
}

-::
{
    DebugRightCtrlMsg("Ctrl + NumpadSub (-) 입력됨")
    Send "{LCtrl Down}{NumpadSub}{LCtrl Up}"
}

=::
{
    DebugRightCtrlMsg("Ctrl + NumpadAdd (+) 입력됨")
    Send "{LCtrl Down}{NumpadAdd}{LCtrl Up}"
}

\::
{
    DebugRightCtrlMsg("Home 입력됨")
    Send "{Home}"
}

0::
{
    DebugRightCtrlMsg("Numpad0 입력됨")
    Send "{Numpad0}"
}

#HotIf