#Requires AutoHotkey v2.0
#SingleInstance Force

global RMB_Held := false
global KeyStates := Map("Up", false, "Down", false, "Left", false, "Right", false)
global MoveAmount := 15

; =========================
; Alt + NumpadEnter : RMB 토글 (언리얼 전용)
; =========================
!NumpadEnter::
{
    global RMB_Held
    winTitle := WinGetTitle("A")
    exeName := ""
    
    try exeName := WinGetProcessName("A")
    
    if (exeName = "UE4Editor.exe" || exeName = "UnrealEditor.exe" || InStr(winTitle, "Unreal Editor"))
    {
        RMB_Held := !RMB_Held
        
        if RMB_Held
            Click("Right", "Down")
        else
            Click("Right", "Up")
    }
    else
    {
        ; 언리얼이 아니면 원래 Alt+NumpadEnter 전달
        Send("!{NumpadEnter}")
    }
}

; =========================
; 방향키 → 마우스 이동 (RMB_Held일 때만)
; =========================
#HotIf RMB_Held

Up::
Down::
Left::
Right::
{
    global MoveAmount, KeyStates
    keyName := A_ThisHotkey
    KeyStates[keyName] := true
    
    Loop 3
    {
        moveX := 0
        moveY := 0
        
        if KeyStates["Left"]
            moveX := MoveAmount
        else if KeyStates["Right"]
            moveX := -MoveAmount
        
        if KeyStates["Up"]
            moveY := MoveAmount
        else if KeyStates["Down"]
            moveY := -MoveAmount
        
        if (moveX != 0 || moveY != 0)
            MouseMove(moveX, moveY, 0, "R")
        
        Sleep(10)
    }
}

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

; =========================
; ESC : 모든 키 상태 + RMB 해제
; =========================
Esc::
{
    global RMB_Held, KeyStates
    
    ; 모든 방향키 상태 해제
    KeyStates["Up"] := false
    KeyStates["Down"] := false
    KeyStates["Left"] := false
    KeyStates["Right"] := false
    
    ; RMB도 해제
    RMB_Held := false
    Click("Right", "Up")
    
    ; ESC 원래 기능도 실행
    Send("{Esc}")
    return
}

#HotIf

; =========================
; 스크립트 종료 시 RMB 정리
; =========================
OnExit(CleanUp)

CleanUp(*)
{
    global RMB_Held
    if RMB_Held
        Click("Right", "Up")
}