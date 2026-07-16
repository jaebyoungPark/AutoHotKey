#Requires AutoHotkey v2.0

; ==============================================================
; 공통 ToolTip 표시 함수
; ==============================================================
ShowVolumeTip(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -500)
}

; ==============================================================
; 볼륨 조절 핵심 로직 (유튜브, 치지직 및 학습 페이지 감지)
; ==============================================================
AdjustVolume(direction) {
    MouseGetPos(&mouseX, &mouseY, &hwnd) ; 마우스 좌표도 함께 가져옵니다.
    if hwnd {
        try {
            title := WinGetTitle("ahk_id " hwnd)
            
            ; 1. 유튜브 창 감지 시 (유튜브 단축키 Shift + Up/Down 사용)
            if InStr(title, "YouTube") {
                WinActivate("ahk_id " hwnd)
                WinWaitActive("ahk_id " hwnd,, 0.5)
                
                ; 유튜브 플레이어가 키 입력을 확실히 받도록 마우스 위치 포커싱
                Click(mouseX, mouseY, 0)
                
                if (direction = "Up")
                    Send("{Up 3}")
                else
                    Send("{Down 3}")
                return "YouTube"
            }
            
; 2. 치지직(CHZZK) 창 감지 시 (방향키 2회 입력으로 조절 속도 UP)
            if InStr(title, "CHZZK") || InStr(title, "치지직") {
                WinActivate("ahk_id " hwnd)
                WinWaitActive("ahk_id " hwnd,, 0.5)
                
                ; 치지직 플레이어 포커싱을 위해 마우스 위치 클릭 (무클릭 포커스)
                Click(mouseX, mouseY, 0)
                
                if (direction = "Up")
                    Send("{Up 3}")  ; Up 방향키를 3번 연속 전송
                else
                    Send("{Down 3}") ; Down 방향키를 3번 연속 전송
                return "Chzzk"
            }
            
            ; 3. 학습 페이지 감지 시
            if InStr(title, "학습 페이지") {
                WinActivate("ahk_id " hwnd)
                WinWaitActive("ahk_id " hwnd,, 0.5)
                if (direction = "Up")
                    Send("{Up}")
                else
                    Send("{Down}")
                return "Study"
            }
        }
    }
    
    ; 4. 위 조건에 해당하지 않으면 시스템 볼륨 조절
    AdjustSystemVolume(direction)
    return "System"
}

; 시스템 볼륨 전용 조절 함수
AdjustSystemVolume(direction) {
    if (direction = "Up")
        Send("{Volume_Up}")
    else
        Send("{Volume_Down}")
}


; ==============================================================
; [그룹 A] 기존 단축키 (스마트 감지 모드)
; ==============================================================

GetTipText(mode, direction) {
    arrow := (direction = "Up") ? "▲" : "▼"
    if (mode = "YouTube")
        return "🎵 YouTube Volume " arrow
    else if (mode = "Chzzk")
        return "💚 CHZZK Volume " arrow
    else if (mode = "Study")
        return "📖 Study Page " arrow
    else
        return ((direction = "Up") ? "🔊" : "🔉") " System Volume " arrow
}

; Ctrl + Shift + 휠 업/다운 (딜레이 완전 제거)
^+WheelUp:: {
    mode := AdjustVolume("Up")
    ShowVolumeTip(GetTipText(mode, "Up"))
}

^+WheelDown:: {
    mode := AdjustVolume("Down")
    ShowVolumeTip(GetTipText(mode, "Down"))
}

; Ctrl + Shift + 키패드/방향키
$^+Home:: {
    mode := AdjustVolume("Up")
    ShowVolumeTip(GetTipText(mode, "Up"))
}

$^+Ins:: {
    mode := AdjustVolume("Down")
    ShowVolumeTip(GetTipText(mode, "Down"))
}

$^+Up:: {
    mode := AdjustVolume("Up")
    ShowVolumeTip(GetTipText(mode, "Up"))
}

$^+Down:: {
    mode := AdjustVolume("Down")
    ShowVolumeTip(GetTipText(mode, "Down"))
}

; Win + Shift + - / =
$#+-:: {
    mode := AdjustVolume("Down")
    ShowVolumeTip(GetTipText(mode, "Down"))
}

$#+=:: {
    mode := AdjustVolume("Up")
    ShowVolumeTip(GetTipText(mode, "Up"))
}


; ==============================================================
; [그룹 B] 신규 단축키 (무조건 시스템 볼륨 조절)
; ==============================================================

; Ctrl + Shift + Alt + 휠 업/다운 (딜레이 완전 제거)
^+!WheelUp:: {
    AdjustSystemVolume("Up")
    ShowVolumeTip("🔊 System Volume ▲")
}

^+!WheelDown:: {
    AdjustSystemVolume("Down")
    ShowVolumeTip("🔉 System Volume ▼")
}

$^+!Up:: {
    AdjustSystemVolume("Up")
    ShowVolumeTip("🔊 System Volume ▲")
}

$^+!Down:: {
    AdjustSystemVolume("Down")
    ShowVolumeTip("🔉 System Volume ▼")
}