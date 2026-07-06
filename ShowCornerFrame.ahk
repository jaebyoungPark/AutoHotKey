; ==========================================================================
; [모서리 프레임 GUI 초기화]
; ==========================================================================
; 💡 맨 뒤에 투명도 인자(alpha)를 추가했습니다. (150 = 반투명 노란색)
global CornerFrameGui := CreateCornerFrame(50, 4, "Yellow", 900, 300, 150) 
global prevFrameState := -1 

; ==========================================================================
; [타이머가 호출할 감시 함수] - (최상단 유지 보정형)
; ==========================================================================
WatchNumSuspendedForFrame()
{
    global NumSuspended, CornerFrameGui, prevFrameState
    
    targetState := (!NumSuspended) ? 1 : 0
    
    if (targetState != prevFrameState)
    {
        if (targetState = 1)
        {
            width := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
            height := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")
            
            ; 1. 보여주기 전에 최상단 속성을 다시 강제로 부여합니다.
            CornerFrameGui.Opt("+AlwaysOnTop") 
            
            CornerFrameGui.Show("x0 y0 w" width " h" height " NoActivate")
        }
        else
        {
            CornerFrameGui.Hide()
        }
        prevFrameState := targetState
    }
    else if (targetState = 1)
    {
        ; 2. 이미 켜진 상태인데 작업 중 뒤로 숨었다면, 주기적으로 다시 맨 앞으로 당겨옵니다.
        CornerFrameGui.Opt("+AlwaysOnTop")
    }
}

; ==========================================================================
; [GUI 최초 생성 함수] - 반투명(Alpha) 조절 추가 버전
; ==========================================================================
CreateCornerFrame(lineLength := 150, lineThick := 5, frameColor := "Yellow", offsetX := 0, offsetY := 0, alpha := 150)
{
    width := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
    height := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")

    ; 투명 GUI 생성
    frameGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000 -DPIScale")
    
    ; 💡 배경색과 투명화 컬러를 다르게 주어 테두리만 남기고, 전체 투명도(alpha)를 먹입니다.
    frameGui.BackColor := "121212" 
    WinSetTransColor("121212 " alpha, frameGui)

    ; --- 좌표 계산 편의를 위한 변수 설정 ---
    w_end := width - offsetX     
    h_end := height - offsetY    

    ; ┌ 좌측 상단
    frameGui.AddText("x" offsetX " y" offsetY " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" offsetX " y" offsetY " w" lineThick " h" lineLength " Background" frameColor)

    ; ┐ 우측 상단
    frameGui.AddText("x" (w_end - lineLength) " y" offsetY " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" (w_end - lineThick) " y" offsetY " w" lineThick " h" lineLength " Background" frameColor)

    ; └ 좌측 하단
    frameGui.AddText("x" offsetX " y" (h_end - lineThick) " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" offsetX " y" (h_end - lineLength) " w" lineThick " h" lineLength " Background" frameColor)

    ; ┘ 우측 하단
    frameGui.AddText("x" (w_end - lineLength) " y" (h_end - lineThick) " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" (w_end - lineThick) " y" (h_end - lineLength) " w" lineThick " h" lineLength " Background" frameColor)

    return frameGui
}