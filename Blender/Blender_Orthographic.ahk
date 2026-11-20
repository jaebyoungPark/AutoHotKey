#Requires AutoHotkey v2.0

;파일명 : Blender_Orthographic.ahk
;카메라 직교 

#HotIf WinActive("ahk_exe blender.exe")

CapsLock & a::
{
    Send "^{Numpad3}"
    ToolTip "Ctrl + Num3"
    SetTimer () => ToolTip(), -700
}

CapsLock & d::
{
    Send "{Numpad3}"
    ToolTip "Num3"
    SetTimer () => ToolTip(), -700
}
 

CapsLock & w::
{
    Send "{Numpad7}"
    ToolTip "Num7"
    SetTimer () => ToolTip(), -700
}

CapsLock & s::
{
    Send "{Numpad1}"
    ToolTip "Num1"
    SetTimer () => ToolTip(), -700
}

CapsLock & x::
{
    Send "^{Numpad7}"
    ToolTip "ctrl+Num7"
    SetTimer () => ToolTip(), -700
}

CapsLock & z::
{
    Send "{Numpad7}"
    ToolTip "Num7"
    SetTimer () => ToolTip(), -700
}


#HotIf