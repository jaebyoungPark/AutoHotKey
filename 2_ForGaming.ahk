; =========================
; F2 즉시 Win + ' 입력
; =========================

F2:: {
    SendEvent "#'"
}


; =========================
; F3 더블클릭 전용
; =========================

~F3:: {
    static lastPressTime := 0
    doubleClickThreshold := 300  ; 300ms

    currentTime := A_TickCount
    timeDiff := currentTime - lastPressTime

    if (timeDiff < doubleClickThreshold) {
        ; ===== 더블클릭 동작 =====
        Send "^#/"   ; Ctrl(^) + Win(#) + /

        lastPressTime := 0
    } else {
        lastPressTime := currentTime
    }
}


; =========================
; Ctrl + Shift + 휠 업 → 볼륨 업
; =========================

^+WheelUp:: {
    Send "{Volume_Up}"
}


; =========================
; Ctrl + Shift + 휠 다운 → 볼륨 다운
; =========================

^+WheelDown:: {
    Send "{Volume_Down}"
}