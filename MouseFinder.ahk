#Requires AutoHotkey v2.0
#SingleInstance Force

; --- 설정 ---
Interval := 4000       ; [수정] 4초마다 실행 (4000ms)
MaxRadius := 105       ; 원이 커질 최대 반지름
MaxSize := MaxRadius * 2

; 변경할 색상 리스트
Colors := ["FF0000", "FF7F00", "FFFF00", "00FF00", "0000FF", "4B0082", "8B00FF"]
ColorIndex := 1        

; 4초마다 마우스 위치를 가리키는 함수 실행
SetTimer(ShowMouseIndicator, Interval)

; 핫키 (Ctrl + Alt + M 으로 토글)
^!m:: {
    static toggle := true
    toggle := !toggle
    if toggle {
        SetTimer(ShowMouseIndicator, Interval)
        ToolTip("마우스 인디케이터 활성화")
    } else {
        SetTimer(ShowMouseIndicator, 0)
        ToolTip("마우스 인디케이터 비활성화")
    }
    SetTimer(() => ToolTip(), -1500)
}

ShowMouseIndicator() {
    global ColorIndex
    
    CoordMode("Mouse", "Screen")
    ; 함수가 시작될 때의 최초 마우스 위치 저장
    MouseGetPos(&startX, &startY)
    
    CurrentColor := Colors[ColorIndex]
    ColorIndex := (ColorIndex >= Colors.Length) ? 1 : ColorIndex + 1
    
    ; 인디케이터용 GUI 생성
    indicator := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000")
    indicator.BackColor := CurrentColor
    
    ; 마우스 중심에 최대 크기로 GUI 창 설정
    indicator.Show("X" (startX - MaxRadius) " Y" (startY - MaxRadius) " W" MaxSize " H" MaxSize " NoActivate Hide")
    
    ; --- 애니메이션 속도 제어 [수정] ---
    LoopCount := 50       ; 애니메이션 총 프레임 수 (기존 40)
    AnimationSleep := 25  ; 프레임당 대기 시간 (기존 15ms -> 25ms로 늘려 더 천천히 퍼짐)

    Loop LoopCount {
        if !WinExist(indicator)
            break
            
        ; 마우스 움직임 감지 로직
        MouseGetPos(&currentX, &currentY)
        if (Abs(currentX - startX) > 3 || Abs(currentY - startY) > 3)
            break
            
        ; 현재 프레임의 반지름 계산 (점점 커짐)
        currentRadius := Integer((A_Index / LoopCount) * MaxRadius)
        if (currentRadius < 1)
            currentRadius := 1
            
        ; 투명도 계산 (점점 흐려짐)
        alpha := Integer(255 * (1 - (A_Index / LoopCount)))
        
        ; GUI 창을 원형 영역(Region)으로 잘라내기
        x1 := MaxRadius - currentRadius
        y1 := MaxRadius - currentRadius
        
        WinSetRegion(x1 "-" y1 " W" (currentRadius * 2) " H" (currentRadius * 2) " Ellipse", indicator)
        WinSetTransparent(alpha, indicator)
        
        ; 첫 프레임에서 창 보이기
        if (A_Index == 1)
            indicator.Show("NoActivate")
            
        Sleep(AnimationSleep) 
    }
    
    ; GUI 제거
    indicator.Destroy()
}