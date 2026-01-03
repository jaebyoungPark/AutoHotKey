;----------------------------
; Chrome에서 Ctrl + 마우스 클릭 매핑
;----------------------------
; Ctrl + 좌클릭 → Ctrl+Shift+Tab
!LButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("^+{Tab}")
    }
    else {
        Send("^{LButton}")  ; 다른 프로그램에선 원래 동작
    }
}

; Ctrl + 우클릭 → Ctrl+Tab
!RButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("^{Tab}")
    }
    else {
        Send("^{RButton}")  ; 다른 프로그램에선 원래 동작
    }
}