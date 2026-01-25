#Requires AutoHotkey v2.0



RButton:: {
    start := A_TickCount
    MouseGetPos &sx, &sy
    isDrag := false

    ; 버튼이 눌려 있는 동안 감시
    while GetKeyState("RButton", "P") {
        Sleep 10
        MouseGetPos &cx, &cy
        if (Abs(cx - sx) > 4 || Abs(cy - sy) > 4) {
            isDrag := true
            break
        }
        if ((A_TickCount - start) > 200)
            break
    }

    ; 드래그 판정 시
    if (isDrag) {
        Send "{RButton Down}"
        KeyWait "RButton"
        Send "{RButton Up}"
        return
    }

    KeyWait "RButton"
    MouseGetPos &ex, &ey
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed < 0.20) {
        Send "{RButton}"
    } else if (elapsed < 0.55) {
        SendInput "#'"
        ; 여기까지 기존 Win+' 실행
    }
}

; -------------------------
; 새로 추가: Win + Page Down
#PgDn:: {
    SendInput "#'"
}