#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키
; ==============================

$!j:: Send "{Alt Down}{Left}"
$!l:: Send "{Alt Down}{Right}"
$!i:: Send "{Alt Down}{Up}"
$!k:: Send "{Alt Down}{Down}"

; ==============================
; 파일 탐색기 / 크롬 전용 단축키
; ==============================

$!a::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
        Send("{Alt Down}{Left}")
    else if WinActive("ahk_class Chrome_WidgetWin_1")
        Send("{Down 2}")
    else
        Send("{Enter}")
}

$!d::
{
    ; 1. 파일 탐색기인 경우
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Right}"
    }
    ; 2. Visual Studio인 경우
    else if WinActive("ahk_exe devenv.exe")
    {
        try focusedHwnd := ControlGetFocus("A")
        if !focusedHwnd
            focusedHwnd := WinGetID("A")
        
        ; 💡 한/영 키를 누르는 게 아니라 시스템 레벨에서 영문 모드로 '강제 고정'합니다.
        SetEnglishMode(focusedHwnd)
        
        Sleep(50) ; 단축키가 씹히지 않도록 아주 잠깐의 딜레이
        Send "!" . "d"
    }
    ; 3. 그 외 기타 프로그램인 경우
    else
    {
        Send "!" . "d"
    }
}

; ==========================================================
; 💡 IME(한영) 상태를 분석하지 않고 '무조건 영어'로 전환하는 함수
; ==========================================================
SetEnglishMode(hwnd) {
    ; IME 기본 윈도우 핸들 구하기
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (!hIME)
        return
        
    ; 0x0283 = WM_IME_CONTROL
    ; WParam을 0x0006 (IMC_SETCONVERSIONMODE)으로 지정하고
    ; LParam을 0 (IME_CMODE_ALPHANUMERIC, 즉 영문)으로 던져서 강제 고정합니다.
    DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 0x0006, "Ptr", 0, "Ptr")
}

$!w::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
        Send "{Alt Down}{Up}"
    else if WinActive("ahk_class Chrome_WidgetWin_1")
        Send "{Up}"
    else
        Send "!" . "w"
}

$!s::
{
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
        Send "{Alt Down}{Down}"
    else if WinActive("ahk_class Chrome_WidgetWin_1")
        Send "{Down}"
    else
        Send "!" . "s"
}

$!q::
{
    ToolTip("Backspace")
    Send("{Backspace}")
    SetTimer(() => ToolTip(), -1000)
}

$!e::
{
    if WinActive("ahk_class Chrome_WidgetWin_1")
        Send "{Enter}"
    else
        Send "!" . "e"
}

; ==========================================
; 💡 한글 모드 체크 함수 (v2 올바른 DllCall 타입 적용)
; ==========================================
IsKoreanMode(hwnd) {
    ; IME 기본 윈도우 핸들 구하기
    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (!hIME)
        return false
        
    ; 💡 WParam, LParam 대신 v2 규격에 맞게 "UPtr", "Ptr"로 수정했습니다.
    ; 0x0283 = WM_IME_CONTROL, 0x0005 = IMC_GETCONVERSIONMODE
    conversionMode := DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 0x0005, "Ptr", 0, "Ptr")
    
    ; 결과값의 1번째 비트가 1이면 한글, 0이면 영어 모드입니다.
    return (conversionMode & 1)
}