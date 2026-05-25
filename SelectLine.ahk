#Requires AutoHotkey v2.0

global LStartTime := 0

; -------------------------------------------------------------------------
; [조건 지정] 아래 조건이 참(True)일 때만 마우스 단축키가 동작합니다.
; -------------------------------------------------------------------------
#HotIf WinActive("ahk_exe devenv.exe") 
    || WinActive("ahk_exe notepad.exe") 
    || InStr(WinGetTitle("A"), "Visual Studio")
; -------------------------------------------------------------------------

~!LButton::
{
    global LStartTime
    LStartTime := A_TickCount
}

~!LButton Up::
{
    global LStartTime
    
    holdTime := A_TickCount - LStartTime
    MouseGetPos &x, &y

    ; 짧게 클릭 (0.25초 미만)
    if (holdTime < 250)
    {
        ; 원래 Alt+클릭 정보가 이미 흘러들어갔으므로, 
        ; 여기서는 순수하게 줄 선택(Home -> Shift+End)만 보냅니다.
        Send "{Home}+{End}"
    }
    else
    {
        ; 길게 누름
        ToolTip "드래그/홀드", x + 12, y + 12
        SetTimer () => ToolTip(), -600
    }
}

#HotIf ; 조건부 단축키 영역 종료 (이 아래로는 다시 일반 단축키가 됨)