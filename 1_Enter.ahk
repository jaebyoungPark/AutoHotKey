#Requires AutoHotkey v2.0
#SingleInstance Force

enterPressTime := 0
isHolding := false

; ------------------------- 
; 상단 Enter (Win + Enter)
#Enter::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Enter Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; 넘패드 Enter
#NumpadEnter::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#NumpadEnter Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; Win + Numpad0
#Numpad0::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#Numpad0 Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 300 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; Ctrl + Enter → Ctrl + 클릭
^Enter::
{
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "Enter"
    Send "{LButton Up}{Ctrl Up}"
}

^NumpadEnter::
{
    Send "{Ctrl Down}{LButton Down}"
    KeyWait "NumpadEnter"
    Send "{LButton Up}{Ctrl Up}"
}

; ------------------------- 
; Win + Page Up
#PgUp::
{
    global enterPressTime
    enterPressTime := A_TickCount
    Send "{LButton Down}"
}

#PgUp Up::
{
    global enterPressTime, isHolding
    holdDuration := A_TickCount - enterPressTime
    
    if (holdDuration >= 250 && holdDuration <= 1000) {
        isHolding := true
        ToolTip "눌림"
        SetTimer () => ToolTip(), -1000
    }
    else {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; 실제 마우스 클릭 → 홀드 해제
~LButton::
{
    global isHolding
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
    }
}

; ------------------------- 
; [완벽 통합] Esc → 홀드 중이면 해제 / 평상시 단독 입력이면 노란 원 표시
; ------------------------- 
~$Esc::
{
    global isHolding
    
    ; 1. 만약 현재 마우스 드래그 홀드("눌림") 상태라면?
    if (isHolding) {
        Send "{LButton Up}"
        isHolding := false
        ToolTip "Left Click"
        SetTimer () => ToolTip(), -800
        return
    }

    ; 2. [평상시 상태] Esc 키를 누른 시점의 시간 기록 및 감시 시작
    startTime := A_TickCount
    ih := InputHook("V L1 M")
    ih.Start()
    
    ; 사용자가 Esc 키를 손에서 뗄 때까지 대기
    KeyWait("Esc")
    ih.Stop()
    
    ; 다른 키가 섞였거나 400ms 이상 길게 누르고 있었다면 원을 그리지 않음
    if (ih.Input != "" || (A_TickCount - startTime > 400))
        return

    ; ------------------------------------------------------
    ; 오직 평상시에 Esc 키만 툭 눌렀다 뗀 경우에만 노란 원 UI 실행
    ; ------------------------------------------------------
    CoordMode "Mouse", "Screen"
    CircleGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000")
    CircleGui.BackColor := "FFFF00" ; 선명한 노란색 💛

    currentSize := 40      ; 시작 크기
    currentAlpha := 240    ; 시작 투명도
    growAmount := 75       ; 프레임당 커지는 양
    maxLoop := 6           ; 6번 루프

    loop maxLoop
    {
        MouseGetPos(&mX, &mY)
        currentSize += growAmount
        currentAlpha -= 35
        if (currentAlpha < 0)
            currentAlpha := 0

        offsetX := 2
        offsetY := 4
        drawX := mX - (currentSize // 2) + offsetX
        drawY := mY - (currentSize // 2) + offsetY

        ; 🛠️ [수정 완료] "Int currentSize"의 오타를 "Int"로 정상 복구했습니다.
        hRgn := DllCall("gdi32\CreateEllipticRgn", "Int", 0, "Int", 0, "Int", currentSize, "Int", currentSize, "Ptr")
        DllCall("user32\SetWindowRgn", "Ptr", CircleGui.Hwnd, "Ptr", hRgn, "Int", 1)
        WinSetTransparent(currentAlpha, CircleGui)

        CircleGui.Show("x" drawX " y" drawY " w" currentSize " h" currentSize " NoActivate")
        Sleep 35
    }
    CircleGui.Destroy()
}

; -------------------------
; Shift + Enter → 왼쪽 클릭
+Enter::
{
    Send "{LButton}"
    ToolTip "Shift+Enter → Left Click"
    SetTimer () => ToolTip(), -800
}