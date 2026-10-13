#Requires AutoHotkey v2.0 
#SingleInstance Force 

; Ctrl/Alt 조작 시 윈도우 메뉴 및 한글 입력기(IME) 간섭 방지
A_MenuMaskKey := "vkE8" 

; ==================================================
; 단축키 매핑
; ==================================================
$^+a:: HandleCtrlShiftA()
$^+d:: HandleCtrlShiftD()

; ==================================================
; [함수] Ctrl + Shift + A 관련 동작 로직
; ==================================================
; 2. 동작 함수
HandleCtrlShiftA() {
    ; 어떤 키로 실행되었는지 확인하여 대기할 키 설정
    targetKey := InStr(A_ThisHotkey, "NumpadDiv") ? "NumpadDiv" : "a"

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
        SendInput "+{Left}" 
        ToolTip "선택" 
        SetTimer () => ToolTip(), -200 
        return 
    } 

    ; Chrome 
    if WinActive("ahk_exe chrome.exe") 
    { 
        start := A_TickCount 
        KeyWait targetKey  ; 누르고 있는 동안 대기
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
; ==================================================
; [함수] Ctrl + Shift + D 관련 동작 로직
; ==================================================
HandleCtrlShiftD() {
    ; VS Code (Code.exe) 
    if WinActive("ahk_exe Code.exe") 
    { 
        SendInput "+{Right}" 
        
        ToolTip "선택" 
        SetTimer () => ToolTip(), -200 
        return 
    } 

    ; 기타 프로그램 예외 처리
    SendInput "{Blind}^+d"
}