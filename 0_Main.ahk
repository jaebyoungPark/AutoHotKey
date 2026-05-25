#Requires AutoHotkey v2.0

; 메인 스크립트
#Include 0_Includes.ahk

MySuspended     := false

NumSuspended := true
NumPadSuspended := true


; =========================
; 일반 숫자 키
; =========================
NumKeyList := [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9",
    "0"
]
; =========================
; 넘패드 키
; =========================
NumPadKeyList := [
    "Numpad1", "Numpad2", "Numpad3",
    "Numpad4", "Numpad5", "Numpad6",
    "Numpad7", "Numpad8", "Numpad9",

    "NumpadSub", "NumpadAdd",
    "NumpadDiv", "NumpadMult",
    "Numpad0", "NumLock"
]

for key in NumKeyList {
    try {
        Hotkey(key, "Off")
    } catch {
    }
}

for key in NumPadKeyList {
    try {
        Hotkey(key, "Off")
    } catch {
    }
}


;======================================
; Toggle NumPad
;======================================

HotKeyList := [

    ; 마우스
    "RButton", "XButton1", "XButton2", "MButton",
    "LButton", "+!LButton", "+!RButton", "^LButton", "~LButton", "!LButton",

    ; 휠
    "^+WheelUp", "^+WheelDown",
    "!WheelUp",  "!WheelDown",
    "+WheelUp",  "+WheelDown",
    "^!WheelUp", "^!WheelDown",

    ; 숫자
    "$^1", "$^2", "^3", "^4",
    "+1", "+2", "+3", "+4", "8",

    ; 기호/특수
    "$^+=", "^!+p", "^!+o", "$^+a",
    "#+-", "#+=:", "#'", "+!'", "+!;",
    "^``", "^+``", "^SC028", "^+SC028",

    ; 방향키
    "Left", "Right", "Up", "Down",
    "!Left",  "!Right",  "!+Right",  "!+Left",
    "^Left",  "^Right",  "^+Right",  "^+Left",
    "#Left",  "#Right",  "#Up",       "#Down",
    "#^Left", "#^Right", "#^Up",      "#^Down",
    "^+Up",   "^+Down",
    "!Up",    "!Down",
    "!a",     "!d",      "!w",        "!s",
    "!q",     "!e",

    ; PageUp/Down
    "PgUp", "PgDn", "^PgDown",

    ; NumpadEnter
    "#NumpadEnter", "^NumpadEnter", "^!NumpadEnter", "!NumpadEnter",

    ; Win+Numpad
    "#Numpad5", "#Numpad4", "#Numpad1",
    "!Numpad1", "!Numpad2",

    ; 기타 Win키
    "#,", "#.", "#[", "#]", "#End", "#Delete",
    "#1", "#f",

    ; Shift 조합
    "+Delete", "+End", "+,", "+.", "+Enter",

    ; Alt 조합
    "!n", "!m", "!j", "!i", "!k", "!l",
    "!,", "!.",

    ; Ctrl 조합
    "^c", "^t", "^m", "^f", "^i", "^u", "^p", "^o",
    "+A",

    ; 단독키
    "RShift", "~F2", "F12", "Esc",

    ; RShift 조합
    "RShift & Tab",
    "RShift & 1", "RShift & 2", "RShift & 3", "RShift & 4", "RShift & 5",
    "RShift & 6", "RShift & 7", "RShift & 8", "RShift & 9", "RShift & 0",

    ; VK15 (한/영) 조합
    "VK15 & w", "VK15 & a", "VK15 & s", "VK15 & d",

    ; vk19 (한자) 조합
    "vk19 + Q", "vk19 + W", "vk19 + E",
    "vk19 + A", "vk19 + S", "vk19 + D",
    "vk19 + Z", "vk19 + X", "vk19 + C",

    ; LWin 조합
    "LWin & Up", "LWin & Left", "LWin & Down", "LWin & Right",

"^+RButton", "^+LButton", "#LButton", "^RButton", "^LButton",

"1", "2", "3", "4", "5", "6", "7", "8", "9", "0",

"Numpad0", "Numpad1", "Numpad2", "Numpad3",
"Numpad4", "Numpad5", "Numpad6",
"Numpad7", "Numpad8", "Numpad9"
]

; "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음

;======================================
; Shift+F1 + Esc 0.5초 유지 → 종료
;======================================

~+F1::
{
    start := A_TickCount

    while GetKeyState("Esc", "P")
    {
        Sleep 10

        if (A_TickCount - start >= 500)
        {
            SoundPlay "C:\Windows\Media\Windows Critical Stop.wav", 1
            ToolTip "🛑 Script Terminated"
            Sleep 500
            ExitApp
        }
    }
}


; ==========================================================================
; [상태 표시 UI 레이어] 이모티콘 교체 + ON 제거 + 마우스 미세 회피 (수정본)
; ==========================================================================

; 1. UI 객체 생성 및 스타일 설정 (가로 폭 및 글꼴 크기 상향)
StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
StatusGui.BackColor := "111111"
StatusGui.SetFont("S11 Bold Q5", "Malgun Gothic") ; S10 -> S11 로 크기 업

guiW := 260  ; UI 가로 폭 확대 (220 -> 260)
StatusText := StatusGui.Add("Text", "cWhite Center W" . guiW, "상태 로딩 중...")
WinSetTransparent(135, StatusGui)

; 기본 위치 정의 (Y=45)
defaultX := (A_ScreenWidth - guiW) // 2
defaultY := 45

; [수정] 피할 위치 조정: 기본 위치에서 아래로 55px 이동 (기존 +35px에서 회피 거리 상향)
dodgeX := defaultX
dodgeY := defaultY + 55

isDodged := false

; 2. UI 표시 및 마우스 위치 감시 함수
UpdateGuiPosition() {
    global isDodged, defaultX, defaultY, dodgeX, dodgeY, guiW
    
    MouseGetPos(&mouseX, &mouseY)
    
    ; [감지 영역 설정] UI 확대에 맞게 터치 범위 자동 조절
xMin := defaultX - 10
xMax := defaultX + guiW + 160
yMin := 0
yMax := defaultY + 100
    
    inZone := (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax)
    
    ; 1) 마우스가 영역 안에 들어왔고, 아직 안 피했을 때 -> 아래로 이동
    if (inZone && !isDodged) {
        isDodged := true
        StatusGui.Show("X" . dodgeX . " Y" . dodgeY . " NoActivate")
    }
    
    ; 2) 마우스가 영역을 벗어났고, 현재 피하고 있는 상태일 때 -> 복귀
    else if (!inZone && isDodged) {
        dxMin := dodgeX - 30
        dxMax := dodgeX + guiW + 30
        dyMin := 0
        dyMax := dodgeY + 45
        
        inDodgeZone := (mouseX >= dxMin && mouseX <= dxMax && mouseY >= dyMin && mouseY <= dyMax)
        
        ; 회피 영역에서도 완전히 마우스가 벗어났을 때 복귀 처리
        if (!inDodgeZone) {
            isDodged := false
            StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
        }
    }
}

; 3. 변수 상태 실시간 업데이트 함수 (글자 레이아웃이 변경되었을 때만 갱신)
UpdateStatusUI() {
    global NumSuspended, NumPadSuspended, StatusText
    static prevText := ""
    
    strNum    := NumSuspended    ? "❌" : "⌨️"
    strPad    := NumPadSuspended ? "❌" : "🔢"
    
    currentText := "[숫자]: " strNum "    |    [넘패드]: " strPad
    
    ; 이전 텍스트와 실제로 달라졌을 경우에만 UI 내부 컴포넌트 데이터 갱신
    if (currentText != prevText) {
        StatusText.Text := currentText
        prevText := currentText
    }
}

; 4. 최초 실행 및 타이머 등록
StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
UpdateStatusUI()

SetTimer(UpdateStatusUI, 200)   
SetTimer(UpdateGuiPosition, 80)