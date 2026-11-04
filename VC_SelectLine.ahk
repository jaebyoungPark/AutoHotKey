#HotIf WinActive("ahk_exe Code.exe")
^+x::
{
    Click
    Send "{Home}"
    Send "+{End}"
    ToolTip "Line Select"
    SetTimer () => ToolTip(), -700
}
#HotIf