#Requires AutoHotkey v2.0

; Ctrl + Up: 누르고 있는 동안 휠업 반복
^Up::
{
    while GetKeyState("Up", "P") ; Up 키가 물리적으로 눌려있는 동안 반복
    {
       SendInput("{WheelUp}")
        Sleep(50) ; 반복 속도 조절 (밀리초)
    }
}

; Ctrl + Down: 누르고 있는 동안 휠다운 반복
^Down::
{
    while GetKeyState("Down", "P") ; Down 키가 물리적으로 눌려있는 동안 반복
    {
        SendInput("{WheelDown}")
        Sleep(50)
    }
}