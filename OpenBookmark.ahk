#Requires AutoHotkey v2.0
#SingleInstance Force

$^+a::
{
    ; Visual Studio (devenv.exe)
    if WinActive("ahk_exe devenv.exe")
    {
        SendEvent "{Ctrl down}k{Ctrl up}"
        Sleep 10
        SendEvent "{Ctrl down}i{Ctrl up}"
        return
    }

; VS Code (Code.exe)
    if WinActive("ahk_exe Code.exe")
    {
        ; {Ctrl up}을 명시하여 물리적으로 눌려있는 Ctrl을 무시하고 Shift + Left만 입력
        SendInput "{Ctrl up}+{Left}"
        
        ; 툴팁 표시 및 0.5초(500ms) 뒤 꺼지도록 설정
        ToolTip "선택"
        SetTimer () => ToolTip(), -200
        return
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe")
    {
        start := A_TickCount
        KeyWait "a"
        elapsed := A_TickCount - start

        if (elapsed < 250)
            SendInput "{Blind}^+a"
        else if (elapsed < 550)
            SendInput "^b"

        return
    }

    ; 기타 프로그램
    SendInput "{Blind}^+a"
}



$^+d::
{
    ; VS Code (Code.exe)
    if WinActive("ahk_exe Code.exe")
    {
        ; {Ctrl up}을 명시하여 물리적으로 눌려있는 Ctrl을 무시하고 Shift + Right 입력
        SendInput "{Ctrl up}+{Right}"
        
        ; 툴팁 표시 및 0.5초(500ms) 뒤 꺼지도록 설정
        ToolTip "선택"
        SetTimer () => ToolTip(), -200
        return
    }

}