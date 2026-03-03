#Requires AutoHotkey v2.0

; 관리자 권한 강제 부여 (스크립트 시작 시 자동으로 물어봄)
if !A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

F1:: {
    MsgBox "오토핫키가 살아있습니다!"
    ; 현재 마우스 위치를 0,0(화면 맨 왼쪽 위)으로 강제 이동
    MouseMove(0, 0, 0)
}