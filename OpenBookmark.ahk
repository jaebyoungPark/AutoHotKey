#Requires AutoHotkey v2.0 
#SingleInstance Force 

; Ctrl/Alt 조작 시 윈도우 메뉴 및 한글 입력기(IME) 간섭 방지
A_MenuMaskKey := "vkE8" 
 
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
        ; {Ctrl up}을 직접 쓰지 않아도 AHK가 자동으로 Ctrl을 제어합니다.
        SendInput "+{Left}" 
 
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
 
    ; Blender 
    if WinActive("ahk_exe blender.exe") 
    { 
        SendInput "^p" 
 
        ToolTip "Blender → Ctrl + P" 
        SetTimer () => ToolTip(), -500 
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
        ; {Ctrl up} 제거
        SendInput "+{Right}" 
         
        ToolTip "선택" 
        SetTimer () => ToolTip(), -200 
        return 
    } 

    ; 기타 프로그램 예외 처리
    SendInput "{Blind}^+d"
}