#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키
; ==============================

$!j::
{
    Send "{Alt Down}{Left}"
}

$!l::
{
    Send "{Alt Down}{Right}"
}

$!i::
{
    Send "{Alt Down}{Up}"
}

$!k::
{
    Send "{Alt Down}{Down}"
}


; ==============================
; 파일 탐색기 / 크롬 전용 단축키
; ==============================

$!a::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send("{Alt Down}{Left}")
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send("{Down 2}")
    }
    ; 그 외 모든 프로그램
    else
    {
        Send("{Enter}")
    }
}

$!d::
{
    ; 1. 파일 탐색기인 경우
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Right}"
    }
    ; 2. Visual Studio인 경우 (한영키 체크 후 !d 수행)
    else if WinActive("ahk_exe devenv.exe")
    {
        hwnd := WinGetID("A")
        
        ; 내부 함수: 현재 한글 입력 상태인지 체크
        IsKoreanMode(winHwnd) {
            if !(hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", winHwnd, "Ptr"))
                return false
            res := DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 1, "Ptr", 0, "Ptr")
            return (res & 1)
        }

        ; 한글 모드라면 영어 모드로 전환
        if IsKoreanMode(hwnd)
        {
            Send("{vk15}") ; 한/영 키 입력
            Sleep(50)      ; 안정적인 전환을 위한 딜레이
        }

        Send("!d")
    }
    ; 3. 그 외 기타 프로그램인 경우
    else
    {
        Send "!d"
    }
}

$!w::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Up}"
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Up}"
    }
    ; 기타 프로그램
    else
    {
        Send "!w"
    }
}

$!s::
{
    ; 파일 탐색기
    if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send "{Alt Down}{Down}"
    }
    ; 크롬
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Down}"
    }
    ; 기타 프로그램
    else
    {
        Send "!s"
    }
}

$!q::
{
    ToolTip("Backspace")
    Send("{Backspace}")
    SetTimer(() => ToolTip(), -1000) ; 1초 후 툴팁 제거
}

$!e::
{
    ; 크롬
    if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send "{Enter}"
    }
    ; 기타 프로그램
    else
    {
        Send "!e"
    }
}