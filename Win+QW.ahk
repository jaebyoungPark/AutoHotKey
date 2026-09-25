#Requires AutoHotkey v2.0

; Win + Q 누르면 마우스 뒤로가기(XButton1) 실행
#q::
{
    Send "{XButton1}"
    ToolTip "← 뒤로가기"
    SetTimer () => ToolTip(), -400
}

; Win + W 누르면 마우스 앞으로가기(XButton2) 실행
#w::
{
    Send "{XButton2}"
    ToolTip "→ 앞으로가기"
    SetTimer () => ToolTip(), -400
}