#Requires AutoHotkey v2.0

; ==========================================================
; 💡 [해결책] 블렌더 전용 독립 핫키 (가장 확실하게 작동)
; ==========================================================
#HotIf WinActive("ahk_exe blender.exe")
$!q::
{
    startTime := A_TickCount
    KeyWait "q"
    duration := A_TickCount - startTime
    
    if (duration < 150)
    {
        Send("!q")  ; 짧게 누르면 블렌더 원래 동작
    }
    else
    {
        ToolTip("Blender: Delete") ; 툴팁 강제 출력
        Send("{Delete}")
        SetTimer(() => ToolTip(), -1000)
    }
}
#HotIf ; 조건 초기화


; ==========================================================
; 💡 일반 프로그램용 핫키 (블렌더가 아닐 때만 작동)
; ==========================================================
$!q::
{

        ToolTip("Backspace")
        Send("{Backspace}")

    
}