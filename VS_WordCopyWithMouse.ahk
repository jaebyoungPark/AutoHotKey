#Requires AutoHotkey v2.0

; ================================
; Ctrl + Shift + 마우스 오른쪽
; ================================
^+RButton::
{
    ; Visual Studio인지 확인
    if WinActive("ahk_exe devenv.exe")
    {
        ; 오른쪽 단어 선택 2번
        Send("^+{Right}")
        Sleep(30)
        Send("^+{Right}")
    }
    else
    {
        ; 원래 마우스 오른쪽 클릭 동작
        Send("{RButton}")
    }
}

; ================================
; Ctrl + Shift + 마우스 왼쪽
; ================================
^+LButton::
{
    ; Visual Studio인지 확인
    if WinActive("ahk_exe devenv.exe")
    {
        Send("^+{Left}")
    }
    else
    {
        ; 원래 마우스 왼쪽 클릭 동작
        Send("{LButton}")
    }
}