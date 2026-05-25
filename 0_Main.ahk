#Requires AutoHotkey v2.0

; 메인 스크립트
#Include 0_Includes.ahk

MySuspended     := false
NumSuspended := true
NumPadSuspended := true

; =========================
; 일반 숫자 키 / 넘패드 키 정의 및 해제
; =========================
NumKeyList := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
NumPadKeyList := ["Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9", "NumpadSub", "NumpadAdd", "NumpadDiv", "NumpadMult", "Numpad0", "NumLock"]

for key in NumKeyList {
    try Hotkey(key, "Off")
}
for key in NumPadKeyList {
    try Hotkey(key, "Off")
}

;======================================
; Shift+F1 + Esc 0.5초 유지 → 종료
;======================================
~+F1:: {
    start := A_TickCount
    while GetKeyState("Esc", "P") {
        Sleep 10
        if (A_TickCount - start >= 500) {
            SoundPlay "C:\Windows\Media\Windows Critical Stop.wav", 1
            ToolTip "🛑 Script Terminated"
            Sleep 500
            ExitApp
        }
    }
}

; ==========================================================================
; [상태 표시 UI 레이어] UI 위치 기반 자동 감지 영역 연동 버전
; ==========================================================================

; 1. UI 객체 생성 및 스타일 설정
StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
StatusGui.BackColor := "111111"
StatusGui.SetFont("S11 Bold Q5", "Malgun Gothic")

guiW := 260  
guiH := 35   
StatusText := StatusGui.Add("Text", "cWhite Center W" . guiW, "상태 로딩 중...")
WinSetTransparent(160, StatusGui)

; ---------------------------------------------------------
; 📍 [UI의 위치를 설정하는 핵심 컨트롤 타워]
; ---------------------------------------------------------
; ① 실제 눈에 보이는 UI 박스의 기본 위치
defaultX := (A_ScreenWidth - guiW) // 2
defaultY := 45

; ② UI가 마우스를 피해 도망갈 위치
dodgeX := defaultX
dodgeY := defaultY + 100 

; ---------------------------------------------------------
; ③ [수정] UI 위치와 상관없이 감지 영역 위치를 강제로 지정하기
; ---------------------------------------------------------
pad := 33                 ; 감지 영역 테두리 여유 공간

; 💡 여기에 원하는 화면 좌표 숫자를 직접 입력하세요! (예: X=700, Y=200 위치)
sensorX := 1150            ; 👈 감지 영역이 시작될 모니터의 X 좌표
sensorY := 45            ; 👈 감지 영역이 시작될 모니터의 Y 좌표

; 감지 영역의 전체 크기 설정 (기존 UI 크기 기반 유지 혹은 숫자로 고정 가능)
sensorW := guiW + (pad * 5) 
sensorH := guiH + (pad * 1.8) 
; ---------------------------------------------------------

isDodged := false

; 2. UI 표시 및 마우스 위치 감시 함수
UpdateGuiPosition() {
    global isDodged, defaultX, defaultY, dodgeX, dodgeY
    global sensorX, sensorY, sensorW, sensorH
    
    MouseGetPos(&mouseX, &mouseY)
    
    ; UI 박스 기본 위치를 기준으로 생성된 영역을 체크합니다.
    xMin := sensorX
    xMax := sensorX + sensorW
    yMin := sensorY
    yMax := sensorY + sensorH
    
    inZone := (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax)
    
    if (!isDodged) {
        ; 마우스가 UI 근처 감지 영역 진입 시 -> 아래로 회피
        if (inZone) {
            isDodged := true
            StatusGui.Show("X" . dodgeX . " Y" . dodgeY . " NoActivate")
        }
    } 
    else {
        ; 마우스가 UI 근처 감지 영역을 완전히 벗어나면 -> 원래 위치 복귀
        if (!inZone) {
            isDodged := false
            StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
        }
    }
}

; 3. 변수 상태 실시간 업데이트 함수
UpdateStatusUI() {
    global NumSuspended, NumPadSuspended, StatusText
    static prevText := ""
    
    strNum    := NumSuspended    ? "❌" : "⌨️"
    strPad    := NumPadSuspended ? "❌" : "🔢"
    
    currentText := "[숫자]: " strNum "    |    [넘패드]: " strPad
    
    if (currentText != prevText) {
        StatusText.Text := currentText
        prevText := currentText
    }
}

; 30초마다 최상단 권한 리프레시
RefreshAlwaysOnTop() {
    global StatusGui
    if WinExist(StatusGui) {
        WinSetAlwaysOnTop(False, StatusGui)
        WinSetAlwaysOnTop(True, StatusGui)
    }
}

; 4. 최초 실행 및 타이머 등록
StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
WinSetAlwaysOnTop(True, StatusGui)
UpdateStatusUI()

SetTimer(UpdateStatusUI, 200)   
SetTimer(UpdateGuiPosition, 80)
SetTimer(RefreshAlwaysOnTop, 30000)