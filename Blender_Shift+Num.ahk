#Requires AutoHotkey v2.0

; ==============================================================================
; 윈도우 타이틀 조건 설정: 활성화된 창이 블렌더(blender.exe)일 때만 아래 핫키들을 작동
; ==============================================================================
#HotIf WinActive("ahk_exe i)blender\.exe")

!1:: {
    ToolTip("Blender Mode: Alt+1 ➔ 1")
    SetTimer(() => ToolTip(), -1000) ; 1초 뒤 툴팁 삭제
    Send "1"
}

!2:: {
    ToolTip("Blender Mode: Alt+2 ➔ 2")
    SetTimer(() => ToolTip(), -1000)
    Send "2"
}

!3:: {
    ToolTip("Blender Mode: Alt+3 ➔ 3")
    SetTimer(() => ToolTip(), -1000)
    Send "3"
}

!4:: {
    ToolTip("Blender Mode: Alt+4 ➔ 4")
    SetTimer(() => ToolTip(), -1000)
    Send "4"
}

!5:: {
    ToolTip("Blender Mode: Alt+5 ➔ 5")
    SetTimer(() => ToolTip(), -1000)
    Send "5"
}

; ==============================================================================
; 조건 해제: 이 라인 아래에 적히는 단축키들은 다시 모든 창에서 공통으로 작동합니다.
; ==============================================================================
#HotIf