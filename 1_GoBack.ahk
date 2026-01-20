#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe devenv.exe")

#,::   ; Win + , (뒤로 가기)
{
    Send "^-"   ; Ctrl + - (마이너스)
}

#.::   ; Win + . (앞으로 가기)
{
    Send "^+-"   ; Ctrl + Shift + - (마이너스)
}

#HotIf