#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키
; ==============================

;$!j:: Send "{Alt Down}{Left}"
;$!l:: Send "{Alt Down}{Right}"
;$!i:: Send "{Alt Down}{Up}"
;$!k:: Send "{Alt Down}{Down}"


; ==============================
; Alt + A
; ==============================

$!a::
{
    ; 1. Blender
    if WinActive("ahk_exe blender.exe")
    {
        ToolTip("Blender: Alt+A")
        Send("!a")
        SetTimer(() => ToolTip(), -1000)
    }
    ; 2. 파일 탐색기
    else if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send("{Alt Down}{Left}")
    }
    ; 3. VS Code
    else if WinActive("ahk_exe Code.exe")
    {
        ToolTip("Left")
        Send("{Left}")
        SetTimer(() => ToolTip(), -1000)
    }
    ; 4. Chrome
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send("{Down 2}")
    }
    ; 5. 그 외
    else
    {
        Send("{Enter}")
    }
}


; ==============================
; Alt + D
; ==============================

$!d::
{
    ; 1. 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Right}"
    }
    ; 2. VS Code
    else if WinActive("ahk_exe Code.exe")
    {
        ToolTip("Right")
        Send "{Right}"
        SetTimer(() => ToolTip(), -1000)
    }
    ; 3. Visual Studio
    else if WinActive("ahk_exe devenv.exe")
    {
        try focusedHwnd := ControlGetFocus("A")
        if !focusedHwnd
            focusedHwnd := WinGetID("A")

        SetEnglishMode(focusedHwnd)

        Sleep(50)
        Send "!" . "d"
    }
    ; 4. 그 외
    else
    {
        Send "!" . "d"
    }
}


; ==============================
; Alt + W
; ==============================

$!w::
{
    ; 1. 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Up}"
    }
    ; 2. Chrome
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Up}"
    }
    ; 3. 그 외
    else
    {
        Send "!" . "w"
    }
}


; ==============================
; Alt + S
; ==============================

$!s::
{
    ; 1. 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Down}"
    }
    ; 2. Chrome
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Down}"
    }
    ; 3. 그 외
    else
    {
        Send "!" . "s"
    }
}


; ==============================
; Alt + Q
; ==============================

$!q::
{
    ; 1. Blender
    if WinActive("ahk_exe blender.exe")
    {
        ToolTip("Delete")
        Send("{Delete}")
        SetTimer(() => ToolTip(), -1000)
    }
    ; 2. 그 외
    else
    {
        ToolTip("Backspace")
        Send("{Backspace}")
        SetTimer(() => ToolTip(), -1000)
    }
}


; ==============================
; Alt + E
; ==============================

$!e::
{
    ; 1. Chrome
    if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Enter}"
    }
    ; 2. 그 외
    else
    {
        Send "!" . "e"
    }
}


; ==========================================================
; IME - 무조건 영어 모드로 전환
; ==========================================================

SetEnglishMode(hwnd)
{
    hIME := DllCall(
        "imm32\ImmGetDefaultIMEWnd",
        "Ptr",
        hwnd,
        "Ptr"
    )

    if (!hIME)
        return

    ; WM_IME_CONTROL
    ; IMC_SETCONVERSIONMODE
    ; 0 = 영어(알파벳) 모드
    DllCall(
        "user32\SendMessage",
        "Ptr",
        hIME,
        "UInt",
        0x0283,
        "UPtr",
        0x0006,
        "Ptr",
        0,
        "Ptr"
    )
}


; ==========================================================
; IME - 한글 모드 확인
; 현재 다른 곳에서 호출되지 않음
; ==========================================================

IsKoreanMode(hwnd)
{
    hIME := DllCall(
        "imm32\ImmGetDefaultIMEWnd",
        "Ptr",
        hwnd,
        "Ptr"
    )

    if (!hIME)
        return false

    conversionMode := DllCall(
        "user32\SendMessage",
        "Ptr",
        hIME,
        "UInt",
        0x0283,
        "UPtr",
        0x0005,
        "Ptr",
        0,
        "Ptr"
    )

    return (conversionMode & 1)
}