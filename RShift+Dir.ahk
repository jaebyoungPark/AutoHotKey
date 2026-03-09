; --- Right Shift + Q/W/E/R → 방향키 1칸 이동 ---

RShift & a::
{
    Send "{Left 1}"
    ToolTip "Left 1칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & s::
{
    Send "{Right 1}"
    ToolTip "Right 1칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & d::
{
    Send "{Up 1}"
    ToolTip "Up 1칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & f::
{
    Send "{Down 1}"
    ToolTip "Down 1칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

; --- Right Shift + A/S/D/F → 방향키 3칸 이동 ---

RShift & q::
{
    Send "{Left 3}"
    ToolTip "Left 3칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & w::
{
    Send "{Right 3}"
    ToolTip "Right 3칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & e::
{
    Send "{Up 3}"
    ToolTip "Up 3칸 이동"
    SetTimer () => ToolTip(), -800
    return
}

RShift & r::
{
    Send "{Down 3}"
    ToolTip "Down 3칸 이동"
    SetTimer () => ToolTip(), -800
    return
}