
#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================================
; 화면 기준 좌표 사용
; ==========================================================
CoordMode "Mouse", "Screen"

; ==========================================================
; Ctrl 누르면 초대형 확산 원 표시 (단독으로 뗄 때만)
; ==========================================================
~Ctrl::
{
    ; 1. Ctrl 키를 누른 시점의 절대 시간 기록
    startTime := A_TickCount
    
    ; 2. Ctrl과 함께 다른 키가 동시에 입력되는지 실시간 감시 (InputHook)
    ih := InputHook("V L1 M")
    ih.Start()
    
    ; 3. 사용자가 Ctrl 키를 손에서 완전히 뗄 때까지 스크립트를 대기시킵니다.
    KeyWait("Ctrl")
    ih.Stop()
    
    ; 💡 [핵심 필터링 안전장치]
    if (ih.Input != "" || (A_TickCount - startTime > 400))
        return

    ; ------------------------------------------------------
    ; 여기서부터는 순수하게 Ctrl 키만 툭 눌렀다 뗀 경우에만 실행됩니다.
    ; ------------------------------------------------------
    
    ; GUI 생성
    CircleGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000")
    
    ; 💡 [색상 변경] FF0000(빨강) -> FFFF00(선명한 노란색 💛)
    CircleGui.BackColor := "FFFF00"

    ; ======================================================
    ; ⏳ 여유로운 잔상 속도 튜닝 설정 값
    ; ======================================================
    currentSize := 40      ; 시작 크기
    currentAlpha := 240    ; 시작 투명도
    growAmount := 75       ; 프레임당 커지는 양
    maxLoop := 6           ; 연산 횟수는 6번으로 고정 (렉 방지)

    loop maxLoop
    {
        ; 현재 마우스 위치
        MouseGetPos(&mX, &mY)

        ; 크기 증가
        currentSize += growAmount

        ; 투명도 감소 폭 완화 (조금 더 화면에 오래 머물도록 35 유지)
        currentAlpha -= 35
        if (currentAlpha < 0)
            currentAlpha := 0

        ; 커서 hotspot 보정
        offsetX := 2
        offsetY := 4

        ; 중심 계산
        drawX := mX - (currentSize // 2) + offsetX
        drawY := mY - (currentSize // 2) + offsetY

        ; 원 Region 생성
        hRgn := DllCall(
            "gdi32\CreateEllipticRgn",
            "Int", 0,
            "Int", 0,
            "Int", currentSize,
            "Int", currentSize,
            "Ptr"
        )

        ; 원 적용
        DllCall(
            "user32\SetWindowRgn",
            "Ptr", CircleGui.Hwnd,
            "Ptr", hRgn,
            "Int", 1
        )

        ; 투명도
        WinSetTransparent(currentAlpha, CircleGui)

        ; 표시
        CircleGui.Show(
            "x" drawX
            " y" drawY
            " w" currentSize
            " h" currentSize
            " NoActivate"
        )

        ; 프레임 간격 (부드럽게 머물다 사라지는 35ms 유지)
        Sleep 35
    }

    CircleGui.Destroy()
}