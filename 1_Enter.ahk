#Requires AutoHotkey v2.0

enterPressTime := 0
isHolding := false

^!Enter:: {
    global enterPressTime, isHolding
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

^!Enter Up:: {
    global enterPressTime, isHolding
    
    holdDuration := A_TickCount - enterPressTime
    
    ; 0.25초(250ms) 이상 0.5초(500ms) 이하로 눌렀을 경우
    if (holdDuration >= 250 && holdDuration <= 500) {
        isHolding := true
        ; 마우스 버튼을 계속 누르고 있는 상태 유지
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000  ; 1초 후 툴팁 제거
    } else {
        ; 그 외의 경우 버튼 릴리즈
        Send "{LButton Up}"
        isHolding := false
    }
}

; 마우스 왼쪽 버튼을 클릭하거나 Esc를 누르면 홀드 해제
~LButton:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
    }
}

~Esc:: {
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
    }
}