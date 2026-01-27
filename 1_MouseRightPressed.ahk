
#Requires AutoHotkey v2.0
#SingleInstance Force

global RMB_Held := false
global KeyStates := Map("Up", false, "Down", false, "Left", false, "Right", false)
global MoveAmount := 15
global DebugMode := true  ; 디버그 모드 ON/OFF

; =========================
; 디버그 출력 함수
; =========================
DebugLog(msg) {
    global DebugMode
    if DebugMode {
        OutputDebug(A_Now " | " msg)
        ToolTip(msg "`n[F12: 디버그 OFF]")
    }
}

; =========================
; F12: 디버그 모드 토글
; =========================
F12:: {
    global DebugMode
    DebugMode := !DebugMode
    if DebugMode
        ToolTip("디버그 모드 ON")
    else
        ToolTip("디버그 모드 OFF")
    SetTimer(() => ToolTip(), -1000)
}

; =========================
; Alt + NumpadEnter 토글 RMB
; =========================
!NumpadEnter:: {
    global RMB_Held
    
    winTitle := WinGetTitle("A")
    exeName := ""
    try {
        exeName := WinGetProcessName("A")
    }
    
    DebugLog("=== Alt+NumpadEnter 누름 ===`n윈도우: " winTitle "`nEXE: " exeName)
    
    if (exeName = "UE4Editor.exe" || exeName = "UnrealEditor.exe" || InStr(winTitle, "Unreal Editor")) {
        RMB_Held := !RMB_Held
        
        if RMB_Held {
            Click("Right", "Down")
            DebugLog("✅ RMB ON - 우클릭 Down 전송")
        } else {
            Click("Right", "Up")
            DebugLog("❌ RMB OFF - 우클릭 Up 전송")
        }
        
        SetTimer(() => ToolTip(), -1500)
    } else {
        DebugLog("⚠️ 언리얼 에디터 아님 - 원래 단축키 전송")
        Send("!{NumpadEnter}")
    }
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
    
    keyName := A_ThisHotkey
    KeyStates[keyName] := true
    
    DebugLog("🔽 키 눌림: " keyName "`nRMB_Held: " RMB_Held "`n현재 상태: " MapToString(KeyStates))
    
    ; 3번 반복 이동
    Loop 3 {
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
        
        if (moveX != 0 || moveY != 0) {
            MouseMove(moveX, moveY, 0, "R")
            DebugLog("🖱 마우스 이동: X=" moveX " Y=" moveY " (반복 " A_Index "/3)")
        } else {
            DebugLog("⚠️ 이동값 0 - moveX=" moveX " moveY=" moveY)
        }
        
        Sleep(10)
    }
    
    SetTimer(() => ToolTip(), -1500)
}

Up Up::
Down Up::
Left Up::
Right Up::
{
    global KeyStates
    
    keyName := StrReplace(A_ThisHotkey, " Up", "")
    KeyStates[keyName] := false
    
    DebugLog("🔼 키 뗌: " keyName "`n현재 상태: " MapToString(KeyStates))
    
    SetTimer(() => ToolTip(), -1500)
}

#HotIf

; =========================
; Map을 문자열로 변환 (디버깅용)
; =========================
MapToString(map) {
    result := ""
    for key, value in map {
        result .= key "=" (value ? "눌림" : "뗌") " | "
    }
    return RTrim(result, " | ")
}

; =========================
; 스크립트 종료 시 정리
; =========================
OnExit(CleanUp)

CleanUp(*) {
    global RMB_Held
    if RMB_Held {
        Click("Right", "Up")
        DebugLog("🛑 스크립트 종료 - RMB 해제")
    }
}