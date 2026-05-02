#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe BeamNG.drive.x64.exe")

WheelUp::
{
    Send "t"
}

WheelDown::
{
    Send "y"
}

#HotIf
; =========================
; Ctrl + Shift + 휠 업 → 볼륨 업
; =========================

^+WheelUp:: {
    Send "{Volume_Up}"
}


; =========================
; Ctrl + Shift + 휠 다운 → 볼륨 다운
; =========================

^+WheelDown:: {
    Send "{Volume_Down}"
}