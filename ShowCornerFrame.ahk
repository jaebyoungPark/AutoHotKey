; ==========================================================================
; [모서리 프레임 GUI 초기화] - 스크립트 시작 시 최초 1회만 생성
; ==========================================================================
global CornerFrameGui := CreateCornerFrame(150, 5, "Red")
global prevFrameState := -1 ; 이전 상태 기억용 (리소스를 아끼기 위해 변경될 때만 작동)

; ==========================================================================
; [타이머가 호출할 감시 함수] - 🔄 false(활성)일 때 켜지도록 반대로 뒤집은 버전
; ==========================================================================
WatchNumSuspendedForFrame()
{
    global NumSuspended, CornerFrameGui, prevFrameState
    
    ; 🔄 NumSuspended가 false(숫자 키 활성화 상태)일 때 1(보임)이 됩니다.
    targetState := (!NumSuspended) ? 1 : 0
    
    ; 상태가 실제로 바뀌었을 때만 GUI를 조작 (화면 깜빡임 방지)
    if (targetState != prevFrameState)
    {
        if (targetState = 1)
        {
            ; 실제 화면 해상도 구하기
            width := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
            height := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")
            CornerFrameGui.Show("x0 y0 w" width " h" height " NoActivate")
        }
        else
        {
            CornerFrameGui.Hide()
        }
        prevFrameState := targetState
    }
}

; ==========================================================================
; [GUI 최초 생성 함수]
; ==========================================================================
CreateCornerFrame(lineLength := 150, lineThick := 5, frameColor := "Red")
{
    width := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
    height := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")

    ; 투명 GUI 생성
    frameGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x80000 -DPIScale")
    frameGui.BackColor := "Black"
    WinSetTransColor("Black", frameGui)

    ; ┌ 좌측 상단
    frameGui.AddText("x0 y0 w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x0 y0 w" lineThick " h" lineLength " Background" frameColor)

    ; ┐ 우측 상단
    frameGui.AddText("x" (width - lineLength) " y0 w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" (width - lineThick) " y0 w" lineThick " h" lineLength " Background" frameColor)

    ; └ 좌측 하단
    frameGui.AddText("x0 y" (height - lineThick) " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x0 y" (height - lineLength) " w" lineThick " h" lineLength " Background" frameColor)

    ; ┘ 우측 하단
    frameGui.AddText("x" (width - lineLength) " y" (height - lineThick) " w" lineLength " h" lineThick " Background" frameColor)
    frameGui.AddText("x" (width - lineThick) " y" (height - lineLength) " w" lineThick " h" lineLength " Background" frameColor)

    return frameGui
}