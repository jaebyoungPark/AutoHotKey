#Requires AutoHotkey v2.0

; 토글 상태 변수 (true로 시작하여 첫 실행시 U가 되도록)
global toggleState := true

; Ctrl + Alt + 마우스 휠 업 (모든 창에서 감지)
^!WheelUp::
{
    global toggleState
    
    ; Visual Studio가 활성화되어 있는지 확인
    if !WinActive("ahk_exe devenv.exe") {
        return  ; Visual Studio가 아니면 아무것도 하지 않음
    }
    
    if (toggleState) {
        ; 주석 해제 (U) - 두 번 실행
        Loop 2 {
            ; Ctrl 누른 상태 유지
            Send "{Ctrl down}"
            Sleep 50
            
            ; K 누르기
            Send "{k down}"
            Sleep 50
            
            ; K 떼기
            Send "{k up}"
            Sleep 50
            
            ; U 누르기 (주석 해제)
            Send "{u down}"
            Sleep 50
            
            ; U 떼기
            Send "{u up}"
            Sleep 50
            
            ; Ctrl 떼기
            Send "{Ctrl up}"
            Sleep 100  ; 두 번째 실행 전 약간의 대기
        }
    } else {
        ; 주석 처리 (C) - 한 번 실행
        ; Ctrl 누른 상태 유지
        Send "{Ctrl down}"
        Sleep 50
        
        ; K 누르기
        Send "{k down}"
        Sleep 50
        
        ; K 떼기
        Send "{k up}"
        Sleep 50
        
        ; C 누르기 (주석 처리)
        Send "{c down}"
        Sleep 50
        
        ; C 떼기
        Send "{c up}"
        Sleep 50
        
        ; Ctrl 떼기
        Send "{Ctrl up}"
    }
    
    ; 토글 상태 전환
    toggleState := !toggleState
}