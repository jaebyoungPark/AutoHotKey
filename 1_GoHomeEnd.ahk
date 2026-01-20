#Requires AutoHotkey v2.0
; =========================
; Visual Studio에서만 동작
; =========================
#HotIf WinActive("ahk_exe devenv.exe")

#[::
{
    HandleBracket("Up")
}

#]::
{
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
    
    ; ✅ 키가 눌려있는 동안 시간 체크
    while (GetKeyState(checkKey, "P"))
    {
        elapsed := A_TickCount - startTime
        
        ; 0.3초 이상 누르면 길게 누른 것으로 판정
        if (elapsed >= 300 && !isLongPress)
        {
            isLongPress := true
            ; 즉시 실행
            if (dir = "Up")
                Send "^{Home}"   ; 최상단
            else
                Send "^{End}"    ; 최하단
            return  ; ✅ 바로 종료
        }
        
        Sleep 10
    }
    
    ; ✅ 짧게 누른 경우만 여기 도달
    if (!isLongPress)
    {
        if (dir = "Up")
            Send "{PgUp}"
        else
            Send "{PgDn}"
    }
}