#Requires AutoHotkey v2.0

; =========================================
; 32인치(2560x1440) 에서의 에디터는 zoom = -2 일때 가능

; 0.3초 이내 → 기존 print text 루틴
; =========================================
^3::
{
if !WinActive("ahk_exe UnrealEditor.exe")
return

StartTime := A_TickCount
KeyWait "3"
Elapsed := (A_TickCount - StartTime) / 1000.0

; =========================================
; 0.3초 이내 → 기존 print text 루틴
; =========================================
if (Elapsed < 0.3)
{
    SendInput "print text"
    Sleep 50

    SendInput "{Enter}"
    Sleep 250

    MouseGetPos &x, &y
    MouseMove x + 6, y + 58, 0
    Sleep 400

    MouseGetPos &x2, &y2

    Click "Down"
    Sleep 50
    MouseMove -150, 100, 10, "R"
    Sleep 70
    Click "Up"
    Sleep 500

    SendInput "format t"
    Sleep 400

    SendInput "{Enter}"
    Sleep 500

    MouseGetPos &x3, &y3
    MouseMove x3 + 72, y3 + 33, 5
    Sleep 200

    Click
    Sleep 80

    SendInput ": {{}0{}},   : {{}1{}}"
    Sleep 120

    SendInput "{Enter}"
}

; =========================================
; 0.3 ~ 1초 → print s 루틴
; =========================================
else if (Elapsed >= 0.3 && Elapsed < 1)
{
    SendText "print s"
    Sleep 50
    Send "{Enter}"
    Sleep 200

    MouseGetPos &x, &y
    MouseMove x + 7.5, y + 62, 0
    Sleep 400

    MouseGetPos &x2, &y2

    Click "Down"
    Sleep 50
    MouseMove -150, 100, 10, "R"
    Sleep 70
    Click "Up"
    Sleep 500

    SendText "ap"
    Sleep 50
    Send "{Enter}"
    Sleep 200

    MouseGetPos &x3, &y3
    MouseMove x3 + 44, y3 + 33, 5
    Sleep 200

    Click
    Sleep 80

    Send "{Space}"
    Sleep 20
    SendText ":"
    Sleep 20
    Send "{Space}"

    Send "{Left 3}"
    Sleep 100
}

}