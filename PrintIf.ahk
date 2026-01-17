#Requires AutoHotkey v2.0

^+i::  ; Ctrl + Shift + I
{
    if WinActive("ahk_exe devenv.exe")  ; Visual Studio만 대상
    {
        ; if () 블록 입력
        SendText "if ()`n{`n}`n"
        
        ; 커서 위로 3번
        Send "{Up 3}"
        
        ; 커서 오른쪽으로 4번
        Send "{Right 4}"
    }
}