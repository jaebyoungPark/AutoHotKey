F2::
{
    CoordMode "Mouse", "Screen"

    ; 현재 마우스 위치 얻기
    MouseGetPos &mouseX, &mouseY

    ; 현재 모니터 개수
    monitorCount := MonitorGetCount()

    currentMonitor := 0

    ; 현재 마우스가 있는 모니터 찾기
    Loop monitorCount
    {
        MonitorGet A_Index, &left, &top, &right, &bottom

        if (mouseX >= left && mouseX <= right && mouseY >= top && mouseY <= bottom)
        {
            currentMonitor := A_Index
            break
        }
    }

    if (currentMonitor = 0)
        return

    ; 다음 모니터 번호 계산 (듀얼 기준이면 1↔2)
    nextMonitor := currentMonitor = 1 ? 2 : 1

    ; 다음 모니터 정보 가져오기
    MonitorGet nextMonitor, &nLeft, &nTop, &nRight, &nBottom

    ; 현재 모니터 정보 다시 가져오기
    MonitorGet currentMonitor, &cLeft, &cTop, &cRight, &cBottom

    ; 현재 모니터 내 상대 비율 계산
    relX := (mouseX - cLeft) / (cRight - cLeft)
    relY := (mouseY - cTop) / (cBottom - cTop)

    ; 다음 모니터의 같은 비율 위치 계산
    newX := nLeft + relX * (nRight - nLeft)
    newY := nTop + relY * (nBottom - nTop)

    ; 마우스 이동
    MouseMove newX, newY, 0
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