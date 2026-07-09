#Requires AutoHotkey v2.0
#SingleInstance Force
; ==========================================================================
; [공용 함수]  - MediaSpeed.ahk, 1_CompileAndSave.ahk
; ==========================================================================
IsUnrealActive() {
    return (
           WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || WinActive("ahk_exe UnrealEditorFortnite-Win64-Shipping.exe")
        || InStr(WinGetTitle("A"), "Unreal Editor")
        || InStr(WinGetTitle("A"), "Unreal Editor for Fortnite")
        || WinActive("ahk_class UnrealWindow")
    )
}
MouseOverExe(exeName) {
    MouseGetPos ,, &hwnd
    try
        return WinGetProcessName("ahk_id " hwnd) = exeName
    catch
        return false
}
EnsureWindowActive(hwnd) {
    if !WinActive("ahk_id " hwnd) {
        WinActivate("ahk_id " hwnd)
        WinWaitActive("ahk_id " hwnd,, 1)
    }
}
IsDev() => (WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe Code.exe"))

WM_SETCURSOR_INTERCEPT(wParam, lParam, msg, hwnd) {
    global isVirtualDown
    if (isVirtualDown)
        return 1
}

; ==========================================================================
; [전역 변수 선언]
; ==========================================================================
global MySuspended      := false
global NumSuspended      := false
global NumPadSuspended  := true
global magnifierOn1     := false
global isComboTriggered := false
global isVirtualDown    := false
unrealExes := ["UE4Editor.exe", "UnrealEditor.exe", "UnrealEditor-Win64-DebugGame.exe", "UnrealEditorFortnite-Win64-Shipping.exe"]

; ==========================================================================
; [인클루드 영역]
; ==========================================================================
#Include 0_Includes.ahk

NumKeyList := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
NumPadKeyList := ["Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8", "Numpad9", "NumpadSub", "NumpadAdd", "NumpadDiv", "NumpadMult", "Numpad0", "NumLock"]

for key in NumKeyList
    try Hotkey(key, NumSuspended ? "Off" : "On")
for key in NumPadKeyList
    try Hotkey(key, NumPadSuspended ? "Off" : "On")

HotKeyList := [
    "RButton", "XButton1", "XButton2", "MButton", "LButton", "+!LButton", "+!RButton", "^LButton", "~LButton", "!LButton",
    "+WheelUp", "^+WheelDown", "!WheelUp", "!WheelDown", "+WheelUp", "+WheelDown", "^!WheelUp", "^!WheelDown",
    "$^1", "$^2", "^3", "^4", "+1", "+2", "+3", "+4", "8", "$^+=", "^!+p", "^!+o", "$^+a",
    "#+-", "#+=:", "#'", "+!'", "+!;", "^``", "^+``", "^SC028", "^+SC028",
    "Left", "Right", "Up", "Down", "!Left", "!Right", "!+Right", "!+Left", "^Left", "^Right", "^+Right", "^+Left",
    "#Left", "#Right", "#Up", "#Down", "#^Left", "#^Right", "#^Up", "#^Down", "+^Up", "^+Down", "!Up", "!Down",
    "!a", "!d", "!w", "!s", "!q", "!e", "PgUp", "PgDn", "^PgDown", "#NumpadEnter", "^NumpadEnter", "^!NumpadEnter", "!NumpadEnter",
    "#Numpad5", "#Numpad4", "#Numpad1", "!Numpad1", "!Numpad2", "#,", "#.", "#[", "#]", "#End", "#Delete", "#1", "#f",
    "+Delete", "+End", "+,", "+.", "+Enter", "!n", "!m", "!j", "!i", "!k", "!l", "!,", "!.",
    "^c", "^t", "^m", "^f", "^i", "^u", "^p", "^o", "+A", "^l", "RShift", "F2", "F12", "Esc", "RShift & Tab",
    "RShift & 1", "RShift & 2", "RShift & 3", "RShift & 4", "RShift & 5", "RShift & 6", "RShift & 7", "RShift & 8", "RShift & 9", "RShift & 0",
    "VK15 & w", "VK15 & a", "VK15 & s", "VK15 & d", "VK15 & 1", "VK15 & 2", "VK15 & 3", "VK15 & 4", "VK15 & 5", "VK15 & 6", "VK15 & 7", "VK15 & 8", "VK15 & 9", "VK15 & 0",
    "vk19 + Q", "vk19 + W", "vk19 + E", "vk19 + A", "vk19 + S", "vk19 + D", "vk19 + Z", "vk19 + X", "vk19 + C",
    "LWin & Up", "LWin & Left", "LWin & Down", "LWin & Right", "^+RButton", "^+LButton", "#LButton", "^RButton", "^LButton", "!d", "^+Space", "NumpadDot", "^v", "^+l", "^+d"
]

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
global defaultX := 0, defaultY := 0
global dodgeX   := 0, dodgeY   := 0
global sensorX  := 0, sensorY  := 0
global sensorW  := 0, sensorH  := 0
global isDodged := false

guiW := 260
guiH := 38
pad  := 50

StatusGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
StatusGui.BackColor := "00FF00"
StatusGui.SetFont("S11 Bold Q4", "Segoe UI")
StatusText := StatusGui.Add("Text", "Center +0x200 Background111111 cWhite W" . guiW . " H" . guiH, "상태 로딩 중...")
WinSetTransColor("00FF00 120", StatusGui)

CheckAndSetResolution() {
    global defaultX, defaultY, dodgeX, dodgeY, sensorX, sensorY, sensorW, sensorH
    global guiW, guiH, pad, StatusGui, isDodged
    sw := A_ScreenWidth
    sh := A_ScreenHeight
    static prevW := 0, prevH := 0

    if (sw != prevW || sh != prevH) {
        if (sw = 2560 && sh = 1440) {
            defaultX := Floor((sw - guiW) / 1.25)
            defaultY := 80
            dodgeX   := defaultX
            dodgeY   := defaultY + 200
            sensorX  := 1800
            sensorY  := 58
        } else if (sw = 1920 && sh = 1080) {
            defaultX := 1400  
            defaultY := 60    
            dodgeX   := defaultX
            dodgeY   := defaultY + 150 
            sensorX  := 1350  
            sensorY  := 40    
        } else {
            defaultX := Floor((sw - guiW) / 2)
            defaultY := 20
            dodgeX   := defaultX
            dodgeY   := defaultY + 100
            sensorX  := defaultX - 20
            sensorY  := defaultY - 20
        }
        sensorW := guiW + (pad * 5)
        sensorH := guiH + (pad * 1.5)
        isDodged := false
        if WinExist(StatusGui)
            StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
        prevW := sw
        prevH := sh
    }
}

UpdateGuiPosition() {
    global isDodged, StatusGui, MySuspended, defaultX, defaultY, dodgeX, dodgeY, sensorX, sensorY, sensorW, sensorH
    if (MySuspended)
        return
    MouseGetPos(&mouseX, &mouseY)
    xMin := sensorX
    xMax := sensorX + sensorW
    yMin := sensorY
    yMax := sensorY + sensorH
    inZone := (mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax)
    if (!isDodged && inZone) {
        isDodged := true
        StatusGui.Show("X" . dodgeX . " Y" . dodgeY . " NoActivate")
    } else if (isDodged && !inZone) {
        isDodged := false
        StatusGui.Show("X" . defaultX . " Y" . defaultY . " NoActivate")
    }
}

UpdateStatusUI() {
    global MySuspended, NumSuspended, NumPadSuspended, StatusText, StatusGui
    if (MySuspended) {
        StatusGui.Hide()
        return
    }
    StatusGui.Show("NoActivate")
    static prevText := ""
    strNum := NumSuspended ? "❌" : "⌨️"
    strPad := NumPadSuspended ? "❌" : "🔢"
    currentText := "[숫자]: " strNum . "    |    [넘패드]: " . strPad
    if (currentText != prevText) {
        StatusText.Text := currentText
        prevText := currentText
    }
}

RefreshAlwaysOnTop() {
    global StatusGui, MySuspended
    if (MySuspended)
        return
    if WinExist(StatusGui) {
        WinSetAlwaysOnTop(False, StatusGui)
        WinSetAlwaysOnTop(True, StatusGui)
    }
}

CheckAndSetResolution() 
WinSetAlwaysOnTop(True, StatusGui)
UpdateStatusUI()
SetTimer(UpdateStatusUI, 200)
SetTimer(UpdateGuiPosition, 80)
SetTimer(CheckAndSetResolution, 30000)
SetTimer(RefreshAlwaysOnTop, 30000)
; 만약 WatchNumSuspendedForFrame 함수가 다른 include 파일에 정의되어 있지 않다면 에러를 피하기 위해 주석처리하거나 유지하십시오.
try SetTimer("WatchNumSuspendedForFrame", 300) 

; ==========================================================================
; [외부 애니메이션 커서(.ani) 주입 + 스크립트 종료 시 자동 복구 레이어]
; ==========================================================================
; [변경점] v2 문법 안정성을 위해 문자열 형태로 등록 및 호출 순서 정돈
; ==========================================================================
; [외부 애니메이션 커서(.ani) 주입 + 스크립트 종료 시 자동 복구 레이어]
; ==========================================================================
; [수정] "ExitReleaseCursor" 문자열 대신 함수 객체 자체를 넘겨줍니다.
OnExit(ExitReleaseCursor)
OnMessage(0x0020, WM_SETCURSOR_INTERCEPT)
SetTimer(WatchCursorByVirtualLock, 100)

WatchCursorByVirtualLock() {
    global isVirtualDown, NumSuspended, NumPadSuspended, MySuspended
    static prevPath := ""
    static prevCrossPath := ""
    targetCrossPath := ""

    ; [경로 유연화] 스크립트 실행 폴더 내의 "Icon And Cursor" 폴더를 기본 경로로 지정
    cursorDir := A_ScriptDir "\Icon And Cursor\"

    if MySuspended {
        targetPath := cursorDir "Suspended3.cur"
        targetCrossPath := cursorDir "Suspended3.cur"
        if (targetPath != prevPath || targetCrossPath != prevCrossPath) {
            SetCustomCursorFile(targetPath, targetCrossPath)
            prevPath := targetPath
            prevCrossPath := targetCrossPath
        }
        return
    }

    if (isVirtualDown) {
        targetCrossPath := cursorDir "Grape_cross.cur"
        if (!NumSuspended && NumPadSuspended)
            targetPath := cursorDir "Grape_Red.cur"
        else if (NumSuspended && !NumPadSuspended)
            targetPath := cursorDir "Grape_Blue.cur"
        else if (NumSuspended && NumPadSuspended)
            targetPath := cursorDir "Grape.cur"
        else
            targetPath := cursorDir "Grape_RedAndBlue.cur"
    } else {
        targetCrossPath := cursorDir "cross_r.cur"
        if (!NumSuspended && NumPadSuspended)
            targetPath := cursorDir "Red.cur"
        else if (NumSuspended && !NumPadSuspended)
            targetPath := cursorDir "Blue.cur"
        else if (NumSuspended && NumPadSuspended)
            targetPath := cursorDir "NotGrape.cur"
        else
            targetPath := cursorDir "RedAndBlue.cur"
    }

    if (targetPath != prevPath || targetCrossPath != prevCrossPath) {
        SetCustomCursorFile(targetPath, targetCrossPath)
        prevPath := targetPath
        prevCrossPath := targetCrossPath
    }
}

SetCustomCursorFile(fullPath, crossPath) {
    static regPath := "HKCU\Control Panel\Cursors"
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "Arrow")
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "AppStarting")
    RegWrite(fullPath, "REG_EXPAND_SZ", regPath, "IBeam")
    if (crossPath != "")
        RegWrite(crossPath, "REG_EXPAND_SZ", regPath, "Crosshair")
    else
        RegWrite("", "REG_EXPAND_SZ", regPath, "Crosshair")
    DllCall("User32.dll\SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}

ResetSystemCursor() {
    static regPath := "HKCU\Control Panel\Cursors"
    cursorDir := A_ScriptDir "\Icon And Cursor\"
    
    RegWrite("", "REG_EXPAND_SZ", regPath, "Arrow")
    RegWrite("", "REG_EXPAND_SZ", regPath, "AppStarting")
    RegWrite("", "REG_EXPAND_SZ", regPath, "IBeam")        
    RegWrite(cursorDir "cross_r.cur", "REG_EXPAND_SZ", regPath, "Crosshair")
    DllCall("User32.dll\SystemParametersInfo", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
}

ExitReleaseCursor(ExitReason, ExitCode) {
    ResetSystemCursor()
    return 0 
}

; ==========================================================================
; [가상 잠금 ON 상태일 때의 키 매핑]
; ==========================================================================
#HotIf isVirtualDown
*q::SendInput "{Blind}5"
*w::SendInput "{Blind}6"
*e::SendInput "{Blind}7"
*r::SendInput "{Blind}8"
*a::SendInput "{Blind}9"
*s::SendInput "{Blind}0"
*d::SendInput "{Blind}."
*f::SendInput "{Blind}{BS}"
*g::SendInput "{Blind}{Enter}"
*z::SendInput "{Blind}{+}"
*x::SendInput "{Blind}-"
*c::SendInput "{Blind}*"
*v::SendInput "{Blind}/"
#HotIf