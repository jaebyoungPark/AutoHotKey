#Requires AutoHotkey v2.0

; 메인 스크립트
#Include 0_Includes.ahk

MySuspended      := false
NumSuspended     := true
NumPadSuspended  := true

; =========================
; 일반 숫자 키 / 넘패드 키 정의 및 해제
; =========================
NumKeyList := [
    "1", "2", "3", "4", "5",
    "6", "7", "8", "9", "0"
]

NumPadKeyList := [
    "Numpad1", "Numpad2", "Numpad3",
    "Numpad4", "Numpad5", "Numpad6",
    "Numpad7", "Numpad8", "Numpad9",
    "NumpadSub", "NumpadAdd",
    "NumpadDiv", "NumpadMult",
    "Numpad0", "NumLock"
]

for key in NumKeyList
{
    try Hotkey(key, "Off")
}

for key in NumPadKeyList
{
    try Hotkey(key, "Off")
}

;======================================
; Toggle NumPad
;======================================

HotKeyList := [

    ; 마우스
    "RButton", "XButton1", "XButton2", "MButton",
    "LButton", "+!LButton", "+!RButton",
    "^LButton", "~LButton", "!LButton",

    ; 휠
    "^+WheelUp", "^+WheelDown",
    "!WheelUp", "!WheelDown",
    "+WheelUp", "+WheelDown",
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
    "!Left", "!Right", "!+Right", "!+Left",
    "^Left", "^Right", "^+Right", "^+Left",
    "#Left", "#Right", "#Up", "#Down",
    "#^Left", "#^Right", "#^Up", "#^Down",
    "^+Up", "^+Down",
    "!Up", "!Down",
    "!a", "!d", "!w", "!s",
    "!q", "!e",

    ; PageUp/Down
    "PgUp", "PgDn", "^PgDown",

    ; NumpadEnter
    "#NumpadEnter", "^NumpadEnter",
    "^!NumpadEnter", "!NumpadEnter",

    ; Win+Numpad
    "#Numpad5", "#Numpad4", "#Numpad1",
    "!Numpad1", "!Numpad2",

    ; 기타 Win키
    "#,", "#.", "#[", "#]",
    "#End", "#Delete",
    "#1", "#f",

    ; Shift 조합
    "+Delete", "+End",
    "+,", "+.", "+Enter",

    ; Alt 조합
    "!n", "!m", "!j",
    "!i", "!k", "!l",
    "!,", "!.",

    ; Ctrl 조합
    "^c", "^t", "^m", "^f",
    "^i", "^u", "^p", "^o",
    "+A",

    ; 단독키
    "RShift", "~F2", "F12", "Esc",

    ; RShift 조합
    "RShift & Tab",
    "RShift & 1", "RShift & 2",
    "RShift & 3", "RShift & 4",
    "RShift & 5", "RShift & 6",
    "RShift & 7", "RShift & 8",
    "RShift & 9", "RShift & 0",

    ; VK15 (한/영) 조합
    "VK15 & w", "VK15 & a",
    "VK15 & s", "VK15 & d",

    ; VK15 숫자 조합 추가
    "VK15 & 1", "VK15 & 2",
    "VK15 & 3", "VK15 & 4",
    "VK15 & 5", "VK15 & 6",
    "VK15 & 7", "VK15 & 8",
    "VK15 & 9", "VK15 & 0",

    ; vk19 (한자) 조합
    "vk19 + Q", "vk19 + W", "vk19 + E",
    "vk19 + A", "vk19 + S", "vk19 + D",
    "vk19 + Z", "vk19 + X", "vk19 + C",

    ; LWin 조합
    "LWin & Up", "LWin & Left",
    "LWin & Down", "LWin & Right",

    "^+RButton", "^+LButton",
    "#LButton", "^RButton", "^LButton",
]

; "^+F11" (GoLeft) 는 토글용이므로 제외

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
; [상태 표시 UI 레이어]
; ==========================================================================

; ==================================================
; 1. UI 객체 생성 및 스타일 설정
; ==================================================

StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")

StatusGui.BackColor := "111111"

StatusGui.SetFont("S11 Bold Q5", "Malgun Gothic")

guiW := 260
guiH := 35

StatusText := StatusGui.Add(
    "Text",
    "cWhite Center W" . guiW,
    "상태 로딩 중..."
)

WinSetTransparent(100, StatusGui)

; ==================================================
; UI 위치 설정
; ==================================================

defaultX := (A_ScreenWidth - guiW) // 2
defaultY := 48

dodgeX := defaultX
dodgeY := defaultY + 200

; ==================================================
; 감지 영역 설정
; ==================================================

pad := 33

sensorX := 1150
sensorY := 10

sensorW := guiW + (pad * 5)
sensorH := guiH + (pad * 2)

isDodged := false

; ==================================================
; 2. UI 표시 및 마우스 위치 감시 함수
; ==================================================

UpdateGuiPosition()
{
    global isDodged
    global defaultX, defaultY
    global dodgeX, dodgeY
    global sensorX, sensorY
    global sensorW, sensorH
    global StatusGui
    global MySuspended

    ; 전체 Suspend 상태면 위치 처리 안함
    if (MySuspended)
        return

    MouseGetPos(&mouseX, &mouseY)

    xMin := sensorX
    xMax := sensorX + sensorW

    yMin := sensorY
    yMax := sensorY + sensorH

    inZone := (
        mouseX >= xMin
        && mouseX <= xMax
        && mouseY >= yMin
        && mouseY <= yMax
    )

    if (!isDodged)
    {
        if (inZone)
        {
            isDodged := true

            StatusGui.Show(
                "X" . dodgeX
                . " Y" . dodgeY
                . " NoActivate"
            )
        }
    }
    else
    {
        if (!inZone)
        {
            isDodged := false

            StatusGui.Show(
                "X" . defaultX
                . " Y" . defaultY
                . " NoActivate"
            )
        }
    }
}

; ==================================================
; 3. 변수 상태 실시간 업데이트 함수
; ==================================================

UpdateStatusUI()
{
    global MySuspended
    global NumSuspended
    global NumPadSuspended
    global StatusText
    global StatusGui

    ; ==================================================
    ; 전체 Suspend 상태면 UI 숨김
    ; ==================================================
    if (MySuspended)
    {
        StatusGui.Hide()
        return
    }

    ; ==================================================
    ; 다시 활성화되면 UI 표시
    ; ==================================================
    StatusGui.Show("NoActivate")

    static prevText := ""

    strNum := NumSuspended ? "❌" : "⌨️"
    strPad := NumPadSuspended ? "❌" : "🔢"

    currentText :=
        "[숫자]: " strNum
        . "    |    [넘패드]: "
        . strPad

    if (currentText != prevText)
    {
        StatusText.Text := currentText
        prevText := currentText
    }
}

; ==================================================
; 30초마다 최상단 권한 리프레시
; ==================================================

RefreshAlwaysOnTop()
{
    global StatusGui
    global MySuspended

    ; Suspend 상태면 무시
    if (MySuspended)
        return

    if WinExist(StatusGui)
    {
        WinSetAlwaysOnTop(False, StatusGui)
        WinSetAlwaysOnTop(True, StatusGui)
    }
}

; ==================================================
; 4. 최초 실행 및 타이머 등록
; ==================================================

StatusGui.Show(
    "X" . defaultX
    . " Y" . defaultY
    . " NoActivate"
)

WinSetAlwaysOnTop(True, StatusGui)

UpdateStatusUI()

SetTimer(UpdateStatusUI, 200)
SetTimer(UpdateGuiPosition, 80)
SetTimer(RefreshAlwaysOnTop, 30000)