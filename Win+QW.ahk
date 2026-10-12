#Requires AutoHotkey v2.0

; Win + Q 누르면 왼쪽 방향키 입력
#q::
{
    Send "{Left}"
    ToolTip "← 뒤로가기"
    SetTimer () => ToolTip(), -400
}

; Win + W 누르면 오른쪽 방향키 입력
#w::
{
    Send "{Right}"
    ToolTip "→ 앞으로가기"
    SetTimer () => ToolTip(), -400
}