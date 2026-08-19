#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe blender.exe")

^!0::
{
    ToolTip("Ctrl + Alt + 0 → Ctrl + Alt + Numpad0")
    SetTimer(() => ToolTip(), -1000)

    Send("^!{Numpad0}")
}

#HotIf