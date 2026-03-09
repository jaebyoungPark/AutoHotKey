#Requires AutoHotkey v2.0
#SingleInstance Force

global RShift_MoveCursor := false

; ==============================
; 🔧 툴팁 관련 함수
; ==============================
ShowTooltip(msg) {
    ToolTip msg
    SetTimer RemoveTooltip, -800  ; 0.8초 후 툴팁 제거
}

RemoveTooltip() {
    ToolTip
}

; ==============================
; 🔧 방향키 이동 함수
; ==============================
SendArrow(key, amount) {
    Send "{" key " " amount "}"
    ShowTooltip(key " " amount "칸 이동")
}

; ==============================
; ▶ RShift + 방향키 단축키
; ==============================
; --- 1칸 이동 ---
RShift & a:: SendArrow("Left", 1)
RShift & s:: SendArrow("Right", 1)
RShift & d:: SendArrow("Up", 1)
RShift & f:: SendArrow("Down", 1)

; --- 3칸 이동 ---
RShift & q:: SendArrow("Left", 3)
RShift & w:: SendArrow("Right", 3)
RShift & e:: SendArrow("Up", 3)
RShift & r:: SendArrow("Down", 3)