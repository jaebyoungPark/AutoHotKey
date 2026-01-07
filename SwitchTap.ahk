#Requires AutoHotkey v2.0
;----------------------------
; Chrome에서 Alt + 마우스 클릭 매핑
;----------------------------

; Alt + 좌클릭 → Ctrl+Shift+Tab (Chrome 전용)

HotkeyList := ["!LButton", "!RButton"]


!LButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send "^+{Tab}"
    } else {
        Send "!{LButton}"
    }
}

; Alt + 우클릭 → 시간에 따라 분기
!RButton:: {
    start := A_TickCount
    KeyWait "RButton"
    elapsed := A_TickCount - start

    ; Chrome에서만 탭 전환 기능 작동
    if WinActive("ahk_exe chrome.exe") {
        if (elapsed < 200) {
            ; 짧게 클릭 → Ctrl + Tab
            Send "^{Tab}"
            return
        }
    }

    ; 200~400ms 구간 돋보기 기능 제거
    ; 500ms 이상 → 아무 것도 안 함
}