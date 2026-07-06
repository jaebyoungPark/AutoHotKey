
HotkeyList := ["^+1","^+2","^+3","^+4"]

#Requires AutoHotkey v2.0

;=============================
; Ctrl+Shift+1~4 → Visual Studio Memory 1~4
;=============================

; Hotkey 등록 (일반 숫자키)
^+1::OpenVSMemory(1)
^+2::OpenVSMemory(2)
^+3::OpenVSMemory(3)
^+4::OpenVSMemory(4)

;=============================
; 함수 정의
;=============================
OpenVSMemory(num) {
    ; Visual Studio 활성화 확인
    if !WinActive("ahk_exe devenv.exe")
        return
    
    ; 메뉴 열기
    Send("!d")  ; Alt + D
    Sleep 100
    Send("w")   ; Windows 메뉴
    Sleep 100
    Send("m")   ; Memory 서브메뉴
    Sleep 100
    
    ; 메뉴 선택 (1~4)
    Send(num)
}