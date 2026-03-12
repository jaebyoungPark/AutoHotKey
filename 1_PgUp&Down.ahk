#Requires AutoHotkey v2.0
; =========================
; Visual Studio에서만 동작
; =========================
#HotIf WinActive("ahk_exe devenv.exe")

#[::
{
    ToolTip "Win + [ 눌림"
    SetTimer () => ToolTip(), -500
    HandleBracket("Up")
}

#]::
{
    ToolTip "Win + ] 눌림"
    SetTimer () => ToolTip(), -500
    HandleBracket("Down")
}

#HotIf

; =========================
; 공통 처리 함수
; =========================
HandleBracket(dir)
{
    checkKey := (dir = "Up") ? "[" : "]"
    startTime := A_TickCount
    isLongPress := false
    
    ToolTip "HandleBracket 시작 (" dir ")"
    SetTimer () => ToolTip(), -500
    
    ; 키가 눌려있는 동안 시간 체크
    while (GetKeyState(checkKey, "P"))
    {
        elapsed := A_TickCount - startTime
        
        ; 0.3초 이상 누르면 길게 누른 것으로 판정
        if (elapsed >= 300 && !isLongPress)
        {
            isLongPress := true
            
            ToolTip "길게 누름 감지 (" dir ")"
            SetTimer () => ToolTip(), -700
            
            if (dir = "Up")
            {
                ToolTip "Ctrl+Home 실행"
                SetTimer () => ToolTip(), -700
                Send "^{Home}"   ; 최상단
            }
            else
            {
                ToolTip "Ctrl+End 실행"
                SetTimer () => ToolTip(), -700
                Send "^{End}"    ; 최하단
            }
            
            return
        }
        
        Sleep 10
    }
    
    ; 짧게 누른 경우
    if (!isLongPress)
    {
        ToolTip "짧게 누름 (" dir ")"
        SetTimer () => ToolTip(), -700
        
        if (dir = "Up")
        {
            ToolTip "PgUp 실행"
            SetTimer () => ToolTip(), -700
            Send "{PgUp}"
        }
        else
        {
            ToolTip "PgDn 실행"
            SetTimer () => ToolTip(), -700
            Send "{PgDn}"
        }
    }
}