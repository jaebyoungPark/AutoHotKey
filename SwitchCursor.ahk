
#Requires AutoHotkey v2.0

HotKeyList := ["RButton"]

RButton::
{
    start := A_TickCount
    MouseGetPos &sx, &sy ; 처음 누른 지점 저장 (시작점)
    isDrag := false
    
    ; 버튼이 눌려 있는 동안 감시
    while GetKeyState("RButton", "P")
    {
        Sleep 10
        MouseGetPos &cx, &cy ; 실시간 위치 추적
        
        ; 5픽셀 이상 움직이면 드래그로 판정
        if (Abs(cx - sx) > 4 || Abs(cy - sy) > 4)
        {
            isDrag := true
            break
        }
        
        ; 0.2초 넘어가면 루프 탈출
        if ((A_TickCount - start) > 200)
            break
    }
    
    ; 드래그 판정 시 로직
    if (isDrag)
    {
        Send "{RButton Down}"
        KeyWait "RButton"
        Send "{RButton Up}"
        return
    }
    
    ; 버튼 떼는 순간까지 대기
    KeyWait "RButton"
    
    ; 떼는 순간 마우스 위치 저장
    MouseGetPos &ex, &ey ; ex, ey = End X, End Y (도착점)
    
    elapsed := (A_TickCount - start) / 1000.0
    
    if (elapsed < 0.20)
    {
        Send "{RButton}"
    }
    else if (elapsed < 0.55)
    {
	

           SendInput "{Alt down}{\ down}{\ up}{Alt up}"
            
            ; 잠깐 대기
            ;Sleep 15
            
            ; 큰 폰트로 설정 (예: 32 크기)
            ;A_DefaultGui := Gui()
            ;A_DefaultGui.SetFont("s48", "Segoe UI Emoji")
            
            ; 마우스 위치에 Here + 웃는 얼굴 표시
            ;MouseGetPos &mx, &my
            ;ToolTip "Here I am😀", mx, my
            
            ;Sleep 600 ; 0.6초 표시
            ;ToolTip ; 제거
            
            ; 폰트 원래대로 복원
            ;A_DefaultGui.SetFont()
        
    }
}