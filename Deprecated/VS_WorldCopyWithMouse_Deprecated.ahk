


#Requires AutoHotkey v2.0

; ================================
; Ctrl + Shift + 마우스 오른쪽
; ================================
^+RButton::
{
    ; Visual Studio인지 확인
    if WinActive("ahk_exe devenv.exe")
    {
        ; 물리 Ctrl 꼬임 방지
        SendEvent "{Blind}{Ctrl Up}"

        Sleep(10)

        ; 오른쪽 단어 선택 2번
        SendEvent "^+{Right}"
        Sleep(30)
        SendEvent "^+{Right}"

        return
    }

    ; 일반 환경
    SendEvent "{RButton}"
}

; ================================
; Ctrl + Shift + 마우스 왼쪽
; ================================
^+LButton::
{
    ; Visual Studio인지 확인
    if WinActive("ahk_exe devenv.exe")
    {
        ; 물리 Ctrl 꼬임 방지
        SendEvent "{Blind}{Ctrl Up}"

        Sleep(10)

        ; 왼쪽 단어 선택
        SendEvent "^+{Left}"

        return
    }

    ; 일반 환경
    SendEvent "{LButton}"
}