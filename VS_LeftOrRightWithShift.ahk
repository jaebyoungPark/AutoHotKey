
#Requires AutoHotkey v2.0

ShowMoveTip(msg) {
    ToolTip msg
    SetTimer () => ToolTip(), -500
}

GetMoveSteps(elapsed, minElapsed, maxElapsed, minSteps, maxSteps)
{
    if (elapsed > maxElapsed)
        elapsed := maxElapsed

    if (elapsed <= 0.3) {
        increments := Floor((elapsed - minElapsed) / 0.04)
        steps := minSteps + increments
    }
    else {
        firstPart := Floor((0.3 - minElapsed) / 0.04)
        increments := Floor((elapsed - 0.3) / 0.035)
        steps := minSteps + firstPart + increments
    }

    if (steps > maxSteps)
        steps := maxSteps

    return steps
}

; ==============================================================================
; 윈도우 타이틀 조건 설정: 활성화된 창이 비주얼 스튜디오(devenv.exe)일 때만 작동
; ==============================================================================
#HotIf WinActive("ahk_exe devenv.exe")

; ==============================
; Shift + Alt + Mouse Left
; ==============================
+!LButton::
{
    start := A_TickCount
    KeyWait "LButton"
    elapsed := (A_TickCount - start) / 1000.0

    minElapsed := 0.2
    maxElapsed := 2.0
    minSteps := 3
    maxSteps := 35

    if (elapsed <= minElapsed) {
        ShowMoveTip("← 1칸 이동")
        Send "+{Left}"
        return
    }

    steps := GetMoveSteps(elapsed, minElapsed, maxElapsed, minSteps, maxSteps)

    ShowMoveTip("← " steps "칸 이동")
    Loop steps
        Send "+{Left}"
}

; ==============================
; Shift + Alt + Mouse Right
; ==============================
+!RButton::
{
    start := A_TickCount
    KeyWait "RButton"
    elapsed := (A_TickCount - start) / 1000.0

    minElapsed := 0.2
    maxElapsed := 2.0
    minSteps := 3
    maxSteps := 35

    if (elapsed <= minElapsed) {
        ShowMoveTip("→ 1칸 이동")
        Send "+{Right}"
        return
    }

    steps := GetMoveSteps(elapsed, minElapsed, maxElapsed, minSteps, maxSteps)

    ShowMoveTip("→ " steps "칸 이동")
    Loop steps
        Send "+{Right}"
}

; ==============================
; Alt + Shift + Left
; ==============================
!+Left::
{
    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    minElapsed := 0.2
    maxElapsed := 2.0
    minSteps := 3
    maxSteps := 35

    if (elapsed <= minElapsed) {
        ShowMoveTip("단어 ← 1칸")
        Send "!+{Left}"
        return
    }

    steps := GetMoveSteps(elapsed, minElapsed, maxElapsed, minSteps, maxSteps)

    ShowMoveTip("단어 ← " steps "칸")
    Loop steps
        Send "!+{Left}"
}

; ==============================
; Alt + Shift + Right
; ==============================
!+Right::
{
    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    minElapsed := 0.2
    maxElapsed := 2.0
    minSteps := 3
    maxSteps := 35

    if (elapsed <= minElapsed) {
        ShowMoveTip("단어 → 1칸")
        Send "!+{Right}"
        return
    }

    steps := GetMoveSteps(elapsed, minElapsed, maxElapsed, minSteps, maxSteps)

    ShowMoveTip("단어 → " steps "칸")
    Loop steps
        Send "!+{Right}"
}

; ==============================================================================
; 조건 해제 (이 아래에 추가되는 단축키는 모든 창에서 기본 작동)
; ==============================================================================
#HotIf