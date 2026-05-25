#Requires AutoHotkey v2.0

global LStartTime := 0

; =========================================================
; [활성 조건]
; ---------------------------------------------------------
; 아래 환경에서만 Alt + 좌클릭 기능 활성화
;
; - Visual Studio
; - 메모장
; - 제목에 "Visual Studio" 포함된 창
; =========================================================
IsSelectLineTarget()
{
    hwnd := WinExist("A")

    ; 활성 창이 없으면 false
    if !hwnd
        return false

    title := WinGetTitle(hwnd)

    return WinActive("ahk_exe devenv.exe")
        || WinActive("ahk_exe notepad.exe")
        || InStr(title, "Visual Studio")
}

#HotIf IsSelectLineTarget()

; =========================================================
; Alt + 좌클릭 Down
; =========================================================
~!LButton::
{
    global LStartTime

    LStartTime := A_TickCount
}

; =========================================================
; Alt + 좌클릭 Up
; =========================================================
~!LButton Up::
{
    global LStartTime

    holdTime := A_TickCount - LStartTime

    MouseGetPos &x, &y

    ; -----------------------------------------------------
    ; 짧게 클릭
    ; -----------------------------------------------------
    if (holdTime < 250)
    {
        ; 현재 줄 전체 선택
        Send "{Home}+{End}"
    }
    ; -----------------------------------------------------
    ; 길게 누름
    ; -----------------------------------------------------
    else
    {
        ToolTip "드래그/홀드", x + 12, y + 12

        SetTimer () => ToolTip(), -600
    }
}

#HotIf