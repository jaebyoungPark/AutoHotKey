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
; 방향키 → 마우스 이동 (RMB_Held일 때만 작동)
; =========================
#HotIf RMB_Held
Up::
Down::
Left::
Right::
{
    global MoveAmount, KeyStates
    
    ; 키 눌림 상태 저장
    keyName := A_ThisHotkey
    KeyStates[keyName] := true
    
    ; 마우스 이동 처리 (3번 반복)
    Loop 3
    {
        moveX := 0
        moveY := 0
        
        ; 수평 이동 (좌우 반전)
        if KeyStates["Left"]
            moveX := MoveAmount
        else if KeyStates["Right"]
            moveX := -MoveAmount
        
        ; 수직 이동 (상하 반전)
        if KeyStates["Up"]
            moveY := MoveAmount
        else if KeyStates["Down"]
            moveY := -MoveAmount
        
        ; 마우스 이동
        if moveX != 0 || moveY != 0
            MouseMove(moveX, moveY, 0, "R")
    }
    return
}

; 키를 뗄 때 상태 초기화
Up Up::
Down Up::
Left Up::
Right Up::
{
    global KeyStates
    keyName := StrReplace(A_ThisHotkey, " Up", "")
    KeyStates[keyName] := false
    return
}
#HotIf