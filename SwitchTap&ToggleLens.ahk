#Requires AutoHotkey v2.0
magnifierOn := false
;----------------------------
; Chrome에서 Alt + 마우스 클릭 매핑
;----------------------------
; Alt + 좌클릭 → Ctrl+Shift+Tab (Chrome 전용)
!LButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send "^+{Tab}"
    } else {
        Send "!{LButton}"
    }
}
; Alt + 우클릭 → 시간에 따라 분기
!RButton:: {
    global magnifierOn
    
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
    
    ; 돋보기는 모든 환경에서 작동
    if (elapsed >= 200 && elapsed < 400) {
        ; 250~500ms → 돋보기 토글
        magnifierOn := !magnifierOn
        if (magnifierOn) {
            ; 돋보기 켜기 (Win + NumpadAdd)
            Send "{LWin down}{NumpadAdd}{LWin up}"
        } else {
            ; 돋보기 끄기 (Win + Esc)
            Send "{LWin down}{Esc}{LWin up}"
            Sleep 100  ; 0.1초 대기
            Send "{f down}"  ; F 키 누름
            Sleep 50         ; 짧은 대기
            Send "{f up}"    ; F 키 뗌
        }
    }
    ; 500ms 이상 → 아무 것도 안 함
}