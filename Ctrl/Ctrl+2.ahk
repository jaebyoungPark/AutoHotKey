#Requires AutoHotkey v2

ShowCtrl2Tip(msg)
{
    ToolTip msg
    SetTimer () => ToolTip(), -700
}

; -----------------------------------------------------------------
; 활성 창이 Visual Studio('devenv.exe')이면서, 동시에 블렌더가 아닐 때만 작동
; -----------------------------------------------------------------
#HotIf WinActive("ahk_exe devenv.exe") and !WinActive("ahk_exe blender.exe")

$^2::
{
    start := A_TickCount
    KeyWait "2"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2초 미만 → *.ToString()
    if (elapsed < 0.2)
    {
        ShowCtrl2Tip("⌨ *.ToString() 입력")
        SendText ", *.ToString()" 
        Send "{Left 11}"
        return
    }

    ; 0.2 ~ 0.55초 → [] : %s
    if (elapsed <= 0.55)
    {
        ShowCtrl2Tip("⌨ [] : %s 입력")
        SendText ", [] : %s" 
        Send "{Left 6}"
        return
    }
}

#HotIf ; HotIf 조건 초기화