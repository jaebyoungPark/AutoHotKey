
#Requires AutoHotkey v2.0

; 단축키 앞에 $를 붙여 Send "{F1}"이 자기 자신을 다시 트리거하는 것을 방지합니다.
$F1::
{
    ; 마우스 좌표 기준을 전체 화면(모니터 기준)으로 설정
    CoordMode "Mouse", "Screen"

    ; ==================================================
    ; 개발 환경 (Unreal / Visual Studio) - 비활성 (주석 유지)
    ; ==================================================
    ; if (
    ;        WinActive("ahk_exe UE4Editor.exe")
    ;     || WinActive("ahk_exe UnrealEditor.exe")
    ;     || InStr(WinGetTitle("A"), "Unreal Editor")
    ;     || WinActive("ahk_class UnrealWindow")
    ;     || WinActive("ahk_exe devenv.exe")
    ; ) {
    ;     ToolTip "🟣 Dev Mode : Mouse Teleport (/)"
    ;     SetTimer () => ToolTip(), -300
    ;
    ;     MoveMouseToOtherMonitor()
    ;     return
    ; }

    ; ==================================================
    ; 즉시 실행 logic
    ; ==================================================
    
    ; 1. 현재 마우스가 위치한 모니터 번호 가져오기
    currentMonitor := MonitorGetFromMouse()
    
    ; 2. 해당 모니터의 상/하/좌/우 모든 경계 좌표 가져오기
    MonitorGet(currentMonitor, &left, &top, &right, &bottom)
    
    ; 3. 좌우 길이의 절반(X) 및 위아래 길이의 절반(Y) 계산
    centerX := left + (right - left) / 2
    centerY := top + (bottom - top) / 2
    
    ; 4. [수정 완료] Integer() 함수를 사용해 소수점을 버리고 정수로 변환하여 API 호출
    DllCall("SetCursorPos", "int", Integer(centerX), "int", Integer(centerY))
    
    ; 5. 기존 #' 단축키 실행 및 클릭
    SendInput "#'"
    Sleep 20
    Click
}

; 현재 마우스 커서가 위치한 모니터 번호만 깔끔하게 반환하는 함수
MonitorGetFromMouse() {
    CoordMode "Mouse", "Screen"
    MouseGetPos &mx, &my
    
    loop MonitorGetCount() {
        MonitorGet A_Index, &l, &t, &r, &b
        if (mx >= l && mx <= r && my >= t && my <= b)
            return A_Index
    }
    return 1
}