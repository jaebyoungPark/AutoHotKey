#Requires AutoHotkey v2.0
global RMB_Held := false
global KeyStates := Map("Up", false, "Down", false, "Left", false, "Right", false)
MoveAmount := 15

; =========================
; Alt + NumpadEnter 토글 RMB
; =========================
!NumpadEnter::
{
    global RMB_Held
    if WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") || InStr(WinGetTitle("A"), "Unreal Editor")
    {
        RMB_Held := !RMB_Held
        if RMB_Held
            Click("Right", "Down")
        else
            Click("Right", "Up")
    }
    else
    {
        Send("!{NumpadEnter}")
    }
    return
}

; =========================
; 방향키 → 마우스 이동 (대각선 지원, 방향 반전, 3번 반복)
; =========================
~Up::
~Down::
~Left::
~Right::
{
    global RMB_Held, MoveAmount, KeyStates
    
    ; 키 눌림 상태 저장
    keyName := StrReplace(A_ThisHotkey, "~", "")
    KeyStates[keyName] := true
    
    ; RMB가 눌려있지 않으면 원래 동작만 수행
    if !RMB_Held
        return
    
    ; 마우스 이동 처리 (3번 반복)
    Loop 3
    {
        moveX := 0
        moveY := 0
        
        ; 수평 이동 (좌우 반전)
        if KeyStates["Left"]
            moveX := MoveAmount  ; Left → 오른쪽
        else if KeyStates["Right"]
            moveX := -MoveAmount  ; Right → 왼쪽
        
        ; 수직 이동 (상하 반전)
        if KeyStates["Up"]
            moveY := MoveAmount  ; Up → 아래
        else if KeyStates["Down"]
            moveY := -MoveAmount  ; Down → 위
        
        ; 마우스 이동
        if moveX != 0 || moveY != 0
            MouseMove(moveX, moveY, 0, "R")
    }
    return
}

; 키를 뗄 때 상태 초기화
~Up Up::
~Down Up::
~Left Up::
~Right Up::
{
    global KeyStates
    keyName := StrReplace(StrReplace(A_ThisHotkey, "~", ""), " Up", "")
    KeyStates[keyName] := false
    return
}