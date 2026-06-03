#Requires AutoHotkey v2.0

#SingleInstance Force



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

; 배경은 투명화용 초록색으로 유지
StatusGui.BackColor := "00FF00"

; 📌 [변경] 이모지와 텍스트 크기 밸런스가 가장 좋고 왜곡이 적은 'Segoe UI' 폰트로 변경합니다.
StatusGui.SetFont("S11 Bold Q4", "Segoe UI")

guiW := 260
guiH := 38  ; 📌 수직 정렬 공간 확보를 위해 높이를 미세하게 조정했습니다.

; 📌 [핵심 변경] 
; 'Center'로 가로 정렬을 잡고, '+0x200'(SS_CENTERIMAGE) 옵션을 추가하여 '수직 가운데 정렬'을 강제합니다.
StatusText := StatusGui.Add(
    "Text",
    "Center +0x200 Background111111 cWhite W" . guiW . " H" . guiH,
    "상태 로딩 중..."
)

; 초록색 날리고 검은색 배경에 투명도 150 부여 (글자는 100% 진하게 유지)
WinSetTransColor("00FF00 120", StatusGui)

; ==================================================

; UI 위치 설정

; ==================================================



defaultX := Floor((A_ScreenWidth - guiW) / 1.25)

defaultY := 80



dodgeX := defaultX

dodgeY := defaultY + 200



; ==================================================

; 감지 영역 설정

; ==================================================



pad := 50



sensorX := 1800

sensorY := 58



sensorW := guiW + (pad * 5)

sensorH := guiH + (pad * 1.5)



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







; ==========================================================================

; [외부 애니메이션 커서(.ani) 주입 + 스크립트 종료 시 자동 복구 레이어]

; ==========================================================================



; 스크립트가 어떤 이유로든 종료될 때(ExitApp 등) 특정 함수를 강제로 실행하도록 등록

OnExit(ExitReleaseCursor)



; 메모장/편집기 등에서 커서가 강제로 풀리는 현상을 원천 차단

OnMessage(0x0020, WM_SETCURSOR_INTERCEPT)



; 0.1초마다 가상잠금 상태를 체크합니다.

SetTimer(WatchCursorByVirtualLock, 100)



SetTimer(WatchCursorByVirtualLock, 100)

WatchCursorByVirtualLock()
{
    global isVirtualDown
    global NumSuspended
    global NumPadSuspended

    static prevPath := ""

    ; ======================================
    ; Virtual Lock ON
    ; ======================================
    if (isVirtualDown)
    {
        if (!NumSuspended && NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\Grape_Red.cur"
        }
        else if (NumSuspended && !NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\Grape_Blue.cur"
        }
        else if (NumSuspended && NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\Grape.cur"
        }
        else
        {
            targetPath := "C:\Windows\Cursors\Grape_RedAndBlue.cur"
        }
    }

    ; ======================================
    ; Virtual Lock OFF
    ; ======================================
    else
    {
        if (!NumSuspended && NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\Red.cur"
        }
        else if (NumSuspended && !NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\Blue.cur"
        }
        else if (NumSuspended && NumPadSuspended)
        {
            targetPath := "C:\Windows\Cursors\NotGrape.cur"
        }
        else
        {
            targetPath := "C:\Windows\Cursors\RedAndBlue.cur"
        }
    }

    ; ======================================
    ; 변경될 때만 적용
    ; ======================================
    if (targetPath != prevPath)
    {
        SetCustomCursorFile(targetPath)
        prevPath := targetPath
    }
}



WM_SETCURSOR_INTERCEPT(wParam, lParam, msg, hwnd)

{

    global isVirtualDown

    if (isVirtualDown)

        return 1

}


SetCustomCursorFile(fullPath)
{
    ; 윈도우 기본 화살표(Arrow), 커서(IBeam) 등의 레지스트리 경로 정의
    static regPath := "HKCU\Control Panel\Cursors"
    
    ; 1. 레지스트리에 변경할 커서 파일 경로 등록 (시스템 기본값 변경 방식)
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "Arrow")      ; 일반 선택 화살표
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "AppStarting") ; 백그라운드 작업 중
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "Arrow")      ; 가상잠금 상태에서 전천후 활용을 위해 덮어씀

    ; 2. SPI_SETCURSORS (0x0057) 명령을 발송하여 윈도우 엔진이 레지스트리를 읽어 
    ;    원본 해상도 및 스케일링을 자동 계산하여 '초고화질'로 다시 그리도록 강제 리프레시합니다.
    DllCall("User32.dll\SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}

; 윈도우 순정 커서 복구 함수도 함께 최적화합니다.
ResetSystemCursor()
{
    static regPath := "HKCU\Control Panel\Cursors"
    
    ; 레지스트리 값을 원래 윈도우 기본값(공백)으로 돌려놓습니다.
    RegWrite("", "REG_EXPAND_SZ", regPath, "Arrow")
    RegWrite("", "REG_EXPAND_SZ", regPath, "AppStarting")
    
    ; 시스템에 원래 테마로 복구하라고 신호를 보냅니다.
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