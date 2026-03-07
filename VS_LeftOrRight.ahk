; --- Alt + Left Arrow ---
!Left::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Left}"
        return
    }

    start := A_TickCount
    KeyWait "Left"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.15) {
        ToolTip "Alt+Left (기본 동작)"
        SetTimer () => ToolTip(), -800
        Send "!{Left}"
        return
    }

    minSteps := 3
    maxSteps := 35
    maxElapsed := 1.0

    if (elapsed > maxElapsed)
        elapsed := maxElapsed

    steps := minSteps

    ; 0.15 ~ 0.3 구간 (0.04 단위)
    if (elapsed <= 0.3) {
        increments := Floor((elapsed - 0.15) / 0.04)
        steps := minSteps + increments
    }
    else {
        ; 0.15~0.3 구간에서 얻는 증가량
        firstPart := Floor((0.3 - 0.15) / 0.04)

        ; 0.3 이후 (0.035 단위)
        increments := Floor((elapsed - 0.3) / 0.035)

        steps := minSteps + firstPart + increments
    }

    if (steps > maxSteps)
        steps := maxSteps

    ToolTip "Left " steps "칸 이동"
    SetTimer () => ToolTip(), -800
    Send "{" "Left " steps "}"
}

; --- Alt + Right Arrow ---
!Right::
{
    if !WinActive("ahk_exe devenv.exe") {
        Send "{Blind}!{Right}"
        return
    }

    start := A_TickCount
    KeyWait "Right"
    elapsed := (A_TickCount - start) / 1000.0

    if (elapsed <= 0.15) {
        ToolTip "Alt+Right (기본 동작)"
        SetTimer () => ToolTip(), -800
        Send "!{Right}"
        return
    }

    minSteps := 3
    maxSteps := 35
    maxElapsed := 1.0

    if (elapsed > maxElapsed)
        elapsed := maxElapsed

    steps := minSteps

    if (elapsed <= 0.3) {
        increments := Floor((elapsed - 0.15) / 0.04)
        steps := minSteps + increments
    }
    else {
        firstPart := Floor((0.3 - 0.15) / 0.04)
        increments := Floor((elapsed - 0.3) / 0.035)
        steps := minSteps + firstPart + increments
    }

    if (steps > maxSteps)
        steps := maxSteps

    ToolTip "Right " steps "칸 이동"
    SetTimer () => ToolTip(), -800
    Send "{" "Right " steps "}"
}