#Requires AutoHotkey v2

HotkeyList := ["$^2"]

$^2::
{
    if !WinActive("ahk_exe devenv.exe")
        return
    SendText(
        "if ()`n"
        . "{`n"
        . "}`n"
        . "else`n"
        . "{`n"
        . "}"
    )
    Send "{Up}{Up}{Up}{Up}{Home}{Right 4}"
}