#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe blender.exe")

^[::
{
    ToolTip("Ctrl + [ → Ctrl + Home")
    Send("{Ctrl down}{Home}{Ctrl up}")
    SetTimer(() => ToolTip(), -1000)
}

^]::
{
    ToolTip("Ctrl + ] → Ctrl + End")
    Send("{Ctrl down}{End}{Ctrl up}")
    SetTimer(() => ToolTip(), -1000)
}

>+[::
{
    ToolTip("RShift + [ → Home")
    Send("{Home}")
    SetTimer(() => ToolTip(), -1000)
}

>+]::
{
    ToolTip("RShift + ] → End")
    Send("{End}")
    SetTimer(() => ToolTip(), -1000)
}

#HotIf