#Requires AutoHotkey v2.0

; ============================== 
; Ctrl + Left
; ============================== 
^Left::
{
    start := A_TickCount
    
    ; Left 키가 물리적으로 떼어질 때까지 기다림 (키 반복 무시)
    KeyWait "Left"
    
    elapsed := (A_TickCount - start) / 1000.0
    
    if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{Home}"
    } else if (elapsed <= 0.20) {
        ; 짧게 누른 경우만 기본 동작
        Send "{Blind}^{Left}"
    }
    ; 0.60초 초과는 아무 동작 안 함
}

; ============================== 
; Ctrl + Right
; ============================== 
^Right::
{
    start := A_TickCount
    
    KeyWait "Right"
    
    elapsed := (A_TickCount - start) / 1000.0
    
    if (elapsed > 0.20 && elapsed <= 0.60) {
        Send "{End}"
    } else if (elapsed <= 0.20) {
        Send "{Blind}^{Right}"
    }
}


