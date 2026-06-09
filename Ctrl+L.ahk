
#Requires AutoHotkey v2.0

; $를 붙여야 Send("^l") 할 때 무한 루프에 빠지지 않습니다.
$^l:: {
    ; 현재 창이 비주얼 스튜디오라면
    if WinActive("ahk_exe devenv.exe") {
        ; 1. 문구만 띄우고
        ToolTip("기능 막아놓음")
        SetTimer(() => ToolTip(), -700)
        
        ; 2. 아무것도 Send하지 않고 여기서 끝냄 (기능 차단)
        return
    }
    
    ; 비주얼 스튜디오가 아닐 때만 원래의 Ctrl + L 신호를 보냄
    Send("^l")
}