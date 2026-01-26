#Requires AutoHotkey v2.0
#SingleInstance Force

global LHoldStart := 0
global IsHolding := false

ShowCursorText(text, duration := 600)
{
    MouseGetPos &x, &y
    ToolTip text, x + 12, y + 12
    SetTimer () => ToolTip(), -duration
}

; =========================
; Win + LButton Down
; =========================
#LButton::
{
    global LHoldStart
    LHoldStart := A_TickCount
    Send "{LButton Down}"
}

; =========================
; Win + LButton Up
; =========================
#LButton Up::
{
    global LHoldStart, IsHolding

    holdTime := A_TickCount - LHoldStart

    ; 0.3초 미만 → 일반 클릭
    if (holdTime < 300)
    {
        Send "{LButton Up}"
        return
    }

    ; 0.3 ~ 0.8초 → 홀드 유지
    if (holdTime <= 800)
    {
        IsHolding := true
        ShowCursorText("눌림")
        return
    }

    ; 0.8초 초과 → 그냥 해제
    Send "{LButton Up}"
}


;1_Enter.ahk 에 있어서 주석처리
; =========================
; 실제 LButton 클릭 시 홀드 해제
; =========================
; ~LButton::
; {
;     global IsHolding
;     if (IsHolding)
;     {
;         Send "{LButton Up}"
;         IsHolding := false
;         ShowCursorText("해제")
;     }
; }

; =========================
; Esc로도 홀드 해제
; =========================
; ~Esc::
; {
;     global IsHolding
;     if (IsHolding)
;     {
;         Send "{LButton Up}"
;         IsHolding := false
;         ShowCursorText("해제")
;     }
; }