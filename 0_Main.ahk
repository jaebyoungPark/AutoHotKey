#Requires AutoHotkey v2.0

#SingleInstance Force

; ==========================================================================
; [공용 함수]  - MediaSpeed.ahk, 1_CompileAndSave.ahk, 안쓰는게 좋음. 활성화 여부를 보장하기 어려워서 마우스클릭으로 명시적 활성화하는게 나음 
; ==========================================================================

; Unreal Engine 활성 판별 함수

IsUnrealActive() {
    return (
           WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || WinActive("ahk_exe UnrealEditorFortnite-Win64-Shipping.exe") ; UEFN 실행 파일 추가
        || InStr(WinGetTitle("A"), "Unreal Editor")
        || InStr(WinGetTitle("A"), "Unreal Editor for Fortnite")       ; UEFN 타이틀 추가
        || WinActive("ahk_class UnrealWindow")                         ; 요청하신 ahk_class (기존과 동일)
    )
}


 MouseOverExe(exeName)
 {
     MouseGetPos ,, &hwnd

     try
         return WinGetProcessName("ahk_id " hwnd) = exeName
     catch
         return false
 }


; GetMouseWindowTitle()
; {
;     MouseGetPos ,, &hwnd
;
;     try
;         return WinGetTitle("ahk_id " hwnd)
;     catch
;         return ""
; }


 EnsureWindowActive(hwnd) {
     if !WinActive("ahk_id " hwnd) {
         WinActivate("ahk_id " hwnd)
         WinWaitActive("ahk_id " hwnd,, 1)
     }
 }

; 개발 환경인지 체크하는 범용 함수
IsDev() => (WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe Code.exe"))

; ==========================================================================

; [전역 변수 선언] - 무조건 #Include 보다 위에 있어야 다른 파일들이 참조할 수 있습니다.

; ==========================================================================

global MySuspended      := false

global NumSuspended      := false

global NumPadSuspended  := true



; ★ mediaspeed.ahk에서 사용하던 변수들을 메인 전역 공간으로 가져왔습니다.

global magnifierOn1     := false

global isComboTriggered := false

global isVirtualDown    := false ; vk15 대신 '잠금 상태'를 기억할 전역 플래그



; [5] Unreal Engine 및 UEFN 특정 기능
    ; 검사할 언리얼 에디터 프로세스 이름 목록
    unrealExes := [
        "UE4Editor.exe", 
        "UnrealEditor.exe", 
        "UnrealEditor-Win64-DebugGame.exe",
        "UnrealEditorFortnite-Win64-Shipping.exe" ; UEFN 조건 추가
    ]



; ==========================================================================

; [인클루드 영역]

; ==========================================================================

#Include 0_Includes.ahk





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


; =========================
; 일반 숫자 키 / 넘패드 키 정의 및 해제
; =========================

; ... (NumKeyList 및 NumPadKeyList 정의 부분은 그대로 유지) ...

; NumSuspended가 true(중지)면 "Off", false(활성)면 "On"
for key in NumKeyList
{
    try Hotkey(key, NumSuspended ? "Off" : "On")
}

; NumPadSuspended가 true(중지)면 "Off", false(활성)면 "On"
for key in NumPadKeyList
{
    try Hotkey(key, NumPadSuspended ? "Off" : "On")
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

    "+A", "^l"



    ; 단독키

    "RShift", "F2", "F12", "Esc",



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

    "!d", "^+Space", "NumpadDot", "^v", "^+l"

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
; [상태 표시 UI 레이어 - 30초 주기 자동 해상도 대응형]
; ==========================================================================

; 전역 좌표 변수 초기 선언
global defaultX := 0, defaultY := 0
global dodgeX   := 0, dodgeY   := 0
global sensorX  := 0, sensorY  := 0
global sensorW  := 0, sensorH  := 0
global isDodged := false

guiW := 260
guiH := 38
pad  := 50

; --------------------------------------------------
; 1. UI 객체 생성 및 스타일 설정
; --------------------------------------------------
StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
StatusGui.BackColor := "00FF00"
StatusGui.SetFont("S11 Bold Q4", "Segoe UI")

StatusText := StatusGui.Add(
    "Text",
    "Center +0x200 Background111111 cWhite W" . guiW . " H" . guiH,
    "상태 로딩 중..."
)

WinSetTransColor("00FF00 120", StatusGui)

; --------------------------------------------------
; 2. 해상도 실시간 감지 및 좌표 갱신 함수 (30초 타이머 작동)
; --------------------------------------------------
CheckAndSetResolution()
{
    global defaultX, defaultY, dodgeX, dodgeY, sensorX, sensorY, sensorW, sensorH
    global guiW, guiH, pad, StatusGui, isDodged

    ; 현재 실행 시점의 해상도 체크
    sw := A_ScreenWidth
    sh := A_ScreenHeight

    static prevW := 0, prevH := 0

    ; 해상도가 이전과 달라졌을 때만 좌표 재계산 (최초 1회 포함)
    if (sw != prevW || sh != prevH)
    {
        if (sw = 2560 && sh = 1440)
        {
            ; ■ [QHD 2560x1440] 설정
            defaultX := Floor((sw - guiW) / 1.25)
            defaultY := 80
            dodgeX   := defaultX
            dodgeY   := defaultY + 200
            sensorX  := 1800
            sensorY  := 58
        }
        else if (sw = 1920 && sh = 1080)
        {
            ; ■ [FHD 1920x1080] 설정 (사용자 지정값)
            defaultX := 1400  
            defaultY := 60    
            dodgeX   := defaultX
            dodgeY   := defaultY + 150 
            sensorX  := 1350  
            sensorY  := 40    
        }
        else
        {
            ; ■ [그 외 해상도] 기본 배치
            defaultX := Floor((sw - guiW) / 2)
            defaultY := 20
            dodgeX   := defaultX
            dodgeY   := defaultY + 100
            sensorX  := defaultX - 20
            sensorY  := defaultY - 20
        }

        ; 감지 영역 크기 계산
        sensorW := guiW + (pad * 5)
        sensorH := guiH + (pad * 1.5)

        ; 해상도가 바뀌면 회피 상태를 초기화하고 기본 위치로 리포지셔닝
        isDodged := false
        if WinExist(StatusGui)
            StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")

        ; 백업
        prevW := sw
        prevH := sh
    }
}

; --------------------------------------------------
; 3. UI 표시 및 마우스 위치 감시 함수
; --------------------------------------------------
UpdateGuiPosition()
{
    global isDodged, StatusGui, MySuspended
    global defaultX, defaultY, dodgeX, dodgeY
    global sensorX, sensorY, sensorW, sensorH

    if (MySuspended)
        return

    MouseGetPos(&mouseX, &mouseY)

    xMin := sensorX
    xMax := sensorX + sensorW
    yMin := sensorY
    yMax := sensorY + sensorH

    inZone := (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax)

    if (!isDodged && inZone)
    {
        isDodged := true
        StatusGui.Show("X" . dodgeX . " Y" . dodgeY . " NoActivate")
    }
    else if (isDodged && !inZone)
    {
        isDodged := false
        StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
    }
}

; --------------------------------------------------
; 4. 변수 상태 실시간 업데이트 함수
; --------------------------------------------------
UpdateStatusUI()
{
    global MySuspended, NumSuspended, NumPadSuspended, StatusText, StatusGui

    if (MySuspended)
    {
        StatusGui.Hide()
        return
    }

    StatusGui.Show("NoActivate")

    static prevText := ""
    strNum := NumSuspended ? "❌" : "⌨️"
    strPad := NumPadSuspended ? "❌" : "🔢"

    currentText := "[숫자]: " strNum . "    |    [넘패드]: " . strPad

    if (currentText != prevText)
    {
        StatusText.Text := currentText
        prevText := currentText
    }
}

; --------------------------------------------------
; 5. 최상단 권한 리프레시 함수
; --------------------------------------------------
RefreshAlwaysOnTop()
{
    global StatusGui, MySuspended
    if (MySuspended)
        return

    if WinExist(StatusGui)
    {
        WinSetAlwaysOnTop(False, StatusGui)
        WinSetAlwaysOnTop(True, StatusGui)
    }
}

; --------------------------------------------------
; 6. 최초 초기화 및 타이머 일괄 등록
; --------------------------------------------------
; 실행하자마자 해상도를 먼저 감지하여 좌표 세팅
CheckAndSetResolution() 

WinSetAlwaysOnTop(True, StatusGui)
UpdateStatusUI()

; 타이머 가동 목록
SetTimer(UpdateStatusUI, 200)      ; UI 텍스트 갱신 (0.2초)
SetTimer(UpdateGuiPosition, 80)    ; 마우스 감지 및 회피 (0.08초)
SetTimer(CheckAndSetResolution, 30000) ; ★ 30초마다 해상도 변경 감지 (자동화)
SetTimer(RefreshAlwaysOnTop, 30000)    ; 30초마다 항상위 권한 리프레시



; ==========================================================================

; [외부 애니메이션 커서(.ani) 주입 + 스크립트 종료 시 자동 복구 레이어]

; ==========================================================================



; 스크립트가 어떤 이유로든 종료될 때(ExitApp 등) 특정 함수를 강제로 실행하도록 등록

OnExit(ExitReleaseCursor)



; 메모장/편집기 등에서 커서가 강제로 풀리는 현상을 원천 차단

OnMessage(0x0020, WM_SETCURSOR_INTERCEPT)



; 0.1초마다 가상잠금 상태를 체크합니다.

SetTimer(WatchCursorByVirtualLock, 100)


WatchCursorByVirtualLock()
{
    global isVirtualDown
    global NumSuspended
    global NumPadSuspended
    global MySuspended

    static prevPath := ""
    static prevCrossPath := ""
    targetCrossPath := ""

    if MySuspended
    {
        targetPath := "C:\Windows\Cursors\Suspended3.cur"
        targetCrossPath := "C:\Windows\Cursors\Suspended3.cur"`

        if (targetPath != prevPath || targetCrossPath != prevCrossPath)
        {
            SetCustomCursorFile(targetPath, targetCrossPath)
            prevPath := targetPath
            prevCrossPath := targetCrossPath
        }

        return
    }

    ; ======================================
    ; Virtual Lock ON (가상 잠금 켜짐)
    ; ======================================
    if (isVirtualDown)
    {
        ; 켜졌을 때는 요청하셨던 Grape_cross.cur 사용
        targetCrossPath := "C:\Windows\Cursors\Grape_cross.cur"

        if (!NumSuspended && NumPadSuspended)
            targetPath := "C:\Windows\Cursors\Grape_Red.cur"
        else if (NumSuspended && !NumPadSuspended)
            targetPath := "C:\Windows\Cursors\Grape_Blue.cur"
        else if (NumSuspended && NumPadSuspended)
            targetPath := "C:\Windows\Cursors\Grape.cur"
        else
            targetPath := "C:\Windows\Cursors\Grape_RedAndBlue.cur"
    }
    ; ======================================
    ; Virtual Lock OFF (가상 잠금 꺼짐)
    ; ======================================
    else
    {
        ; ⭐ 가상 잠금이 꺼지면 기본 cross_r.cur 파일로 지정!
        targetCrossPath := "C:\Windows\Cursors\cross_r.cur"

        if (!NumSuspended && NumPadSuspended)
            targetPath := "C:\Windows\Cursors\Red.cur"
        else if (NumSuspended && !NumPadSuspended)
            targetPath := "C:\Windows\Cursors\Blue.cur"
        else if (NumSuspended && NumPadSuspended)
            targetPath := "C:\Windows\Cursors\NotGrape.cur"
        else
            targetPath := "C:\Windows\Cursors\RedAndBlue.cur"
    }

    ; ======================================
    ; 변경될 때만 적용
    ; ======================================
    if (targetPath != prevPath || targetCrossPath != prevCrossPath)
    {
        SetCustomCursorFile(targetPath, targetCrossPath)
        prevPath := targetPath
        prevCrossPath := targetCrossPath
    }
}

WM_SETCURSOR_INTERCEPT(wParam, lParam, msg, hwnd)

{

    global isVirtualDown

    if (isVirtualDown)

        return 1

}



SetCustomCursorFile(fullPath, crossPath)
{
    static regPath := "HKCU\Control Panel\Cursors"
    
    ; 1. 기존 일반/로딩/텍스트 커서 등록
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "Arrow")       ; 일반 선택 화살표
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "AppStarting")  ; 백그라운드 작업 중
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "IBeam")        ; 텍스트 선택(I-Beam)

    ; 2. 십자선(Crosshair) 커서 등록 처리
    if (crossPath != "")
        RegWrite(crossPath, "REG_EXPAND_SZ", regPath, "Crosshair")
    else
        RegWrite("", "REG_EXPAND_SZ", regPath, "Crosshair") ; 비어있으면 기본값으로

    ; 3. SPI_SETCURSORS (0x0057) 명령 발송하여 시스템 새로고침
    DllCall("User32.dll\SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}

; 윈도우 순정 커서 복구 함수
ResetSystemCursor()
{
    static regPath := "HKCU\Control Panel\Cursors"
    
    ; 레지스트리 값을 원래 기본값으로 복구
    RegWrite("", "REG_EXPAND_SZ", regPath, "Arrow")
    RegWrite("", "REG_EXPAND_SZ", regPath, "AppStarting")
    RegWrite("", "REG_EXPAND_SZ", regPath, "IBeam")        
    
    ; ⭐ 스크립트 종료 시 평상시 쓰던 cross_r.cur 로 복구
    RegWrite("C:\Windows\Cursors\cross_r.cur", "REG_EXPAND_SZ", regPath, "Crosshair")
    
    ; 시스템에 테마 복구 신호 발송
    DllCall("User32.dll\SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}


; ★ [핵심] 스크립트가 꺼질 때 자동으로 호출되는 유언 함수

ExitReleaseCursor(ExitReason, ExitCode)

{

    ResetSystemCursor()

    ; 대기 시간 없이 즉시 종료 처리를 허가함 (0 반환)

    return 0 

}





; ==========================================================================
; [가상 잠금 ON 상태일 때의 키 매핑]
; ==========================================================================
#HotIf isVirtualDown  ; 이 아래의 핫키들은 isVirtualDown이 true(ON)일 때만 동작합니다.

*q::SendInput "{Blind}5"       ; q 누르면 5 입력
*w::SendInput "{Blind}6"       ; w 누르면 6 입력
*e::SendInput "{Blind}7"       ; e 누르면 7 입력
*r::SendInput "{Blind}8"       ; r 누르면 8 입력
*a::SendInput "{Blind}9"       ; a 누르면 9 입력
*s::SendInput "{Blind}0"       ; s 누르면 0 입력
*d::SendInput "{Blind}."       ; d 누르면 마침표(.) 입력
*f::SendInput "{Blind}{BS}"    ; f 누르면 백스페이스(Backspace) 입력
*g::SendInput "{Blind}{Enter}" ; g 누르면 엔터(Enter) 입력

; ➕ [새로 추가된 사칙연산 키 매핑]
*z::SendInput "{Blind}{+}"     ; z 누르면 덧셈(+) 입력 (AHK에서 +는 Shift 의미라 중괄호 처리)
*x::SendInput "{Blind}-"       ; x 누르면 뺄셈(-) 입력
*c::SendInput "{Blind}*"       ; c 누르면 곱셈(*) 입력
*v::SendInput "{Blind}/"       ; v 누르면 나눗셈(/) 입력

#HotIf  ; 핫키 조건 영역을 닫아줍니다 (기존 다른 핫키에 영향 주지 않기 위함)