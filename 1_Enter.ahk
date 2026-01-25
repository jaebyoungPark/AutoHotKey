#Requires AutoHotkey v2.0

enterPressTime := 0
isHolding := false

#Enter:: {   ; Win + Enter
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Enter Up:: {   ; Win + Enter 떼기
    global enterPressTime, isHolding
    
    holdDuration := A_TickCount - enterPressTime
    
    ; 0.25초(250ms) 이상 0.5초(500ms) 이하
    if (holdDuration >= 250 && holdDuration <= 1000) {
        isHolding := true
        ; 마우스 버튼을 계속 누른 상태 유지
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    } else {
        ; 그 외 → 마우스 버튼 릴리즈
        Send "{LButton Up}"
        isHolding := false
    }
}

; 마우스 왼쪽 버튼 클릭 시 홀드 해제
~LButton:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
    }
}

; Esc로도 홀드 해제
~Esc:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
    }
}