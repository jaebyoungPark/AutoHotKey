#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe blender.exe")

RShift & Left::Send "{Numpad4}"
RShift & Up::Send "{Numpad8}"
RShift & Down::Send "{Numpad2}"
RShift & Right::Send "{Numpad6}"
RShift & Enter::Send "{Numpad5}"

#HotIf