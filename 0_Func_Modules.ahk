#Requires AutoHotkey v2.0

; ==================================================
; 전역 상태 (모듈에서 선언, 메인 파일의 핫키도 공유)
; ==================================================
global actionToken := 0        ; 동작 번호표 (새 동작이 시작되면 증가)
global capsComboUsed := false
global capsHeld := false
global capsPrev := false
global capsIdleMs := 5000      ; CapsLock 자동 꺼짐 대기 시간 (메인에서 덮어쓸 수 있음)

; ==================================================
; [함수 1] 창 활성화 / 순환 / 최소화
; ==================================================
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := false) {
    global actionToken
    myToken := actionToken
    static WinIndexes := Map()
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1

    windows := WinGetList(searchTitle)
    count := windows.Length

    ; CASE 1: 창이 하나도 안 켜져 있는 경우 (실행 시도)
    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            if WinWait(searchTitle, , 2.5) {
                if (myToken != actionToken)   ; 그 사이 다른 단축키가 눌림 → 취소
                    return
                if hwnd := WinExist(searchTitle) {
                    coords := GetMouseMonitorCoords()
                    try WinMove(coords.X, coords.Y, , , "ahk_id " hwnd)
                    try WinMaximize("ahk_id " hwnd)
                    return
                }
            }
        }

        if (myToken != actionToken)
            return
        ToolTip("⚠️ 창을 찾을 수 없거나 실행에 실패했습니다.`n조건: " . searchTitle)
        SetTimer(() => ToolTip(), -3000)
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    activeIdx := 0
    for i, h in windows {
        if (h = activeHwnd) {
            activeIdx := i
            break
        }
    }

    ; CASE 2: 매칭된 창이 이미 활성화되어 있는 경우
    if (activeIdx > 0) {
        if (count > 1) {
            currentIndex := (activeIdx >= count) ? 1 : activeIdx + 1
        } else {
            WinMinimize(windows[1])
            return
        }
    }

    ; CASE 3: 대상 창 활성화
    targetHwnd := windows[currentIndex]

    try {
        if (WinGetMinMax("ahk_id " targetHwnd) = -1)
            WinRestore("ahk_id " targetHwnd)

        if (myToken != actionToken)
            return
        WinActivate("ahk_id " targetHwnd)
        WinWaitActive("ahk_id " targetHwnd, , 0.3)

        if (myToken != actionToken)
            return

        if (!WinActive("ahk_id " targetHwnd)) {
            WinSetAlwaysOnTop(1, "ahk_id " targetHwnd)
            Sleep 30
            WinSetAlwaysOnTop(0, "ahk_id " targetHwnd)
            if (myToken != actionToken)
                return
            WinActivate("ahk_id " targetHwnd)
        }

        ; 크롬 창 복원 후 검은 화면 방지 (바탕화면 경유 + 투명도 254)
        if WinActive("ahk_exe chrome.exe") {
            WinSetTransparent(254, "ahk_id " targetHwnd)

            WinActivate("ahk_class Progman")
            Sleep 15
            if (myToken = actionToken)
                WinActivate("ahk_id " targetHwnd)

            WinSetTransparent("Off", "ahk_id " targetHwnd)
        }

        WinIndexes[searchTitle] := currentIndex
    } catch as err {
        ToolTip("⚠️ 창 활성화 중 오류 발생: " . err.Message)
        SetTimer(() => ToolTip(), -3000)
    }
}

; ==================================================
; [함수 2] 사이트 열기 (짧게: 전환 / 길게: 새 탭)
; ==================================================
OpenSite(keyName, searchTitle, url) {
    global actionToken
    myToken := actionToken

    if KeyWait(keyName, "T0.27") {
        if (myToken != actionToken)
            return
        ActivateOrCycleEx(searchTitle . " ahk_exe chrome.exe", 'chrome.exe --new-window "' . url . '"', false)
    } else {
        if (myToken != actionToken)
            return
        if WinActive("ahk_exe chrome.exe") {
            Send "^t"
            Sleep 150
            if (myToken != actionToken)
                return
            SendText url
            Send "{Enter}"
        } else {
            Run 'chrome.exe "' . url . '"'
        }
        KeyWait(keyName)
    }
}

; ==================================================
; [함수 3] 현재 마우스 위치 모니터 좌표 구하기
; ==================================================
GetMouseMonitorCoords() {
    MouseGetPos(&mouseX, &mouseY)
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        if (mouseX >= Left && mouseX <= Right && mouseY >= Top && mouseY <= Bottom)
            return {X: Left, Y: Top}
    }
    MonitorGet(1, &Left, &Top)
    return {X: Left, Y: Top}
}

; ==================================================
; [함수 4] 듀얼 모니터 마우스 순간이동
; ==================================================
MoveMouseToOtherMonitor() {
    monitorCount := MonitorGetCount()
    if (monitorCount < 2)
        return
    CoordMode("Mouse", "Screen")
    MouseGetPos &mouseX, &mouseY
    currentMonitor := 0

    Loop monitorCount {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        if (mouseX >= mLeft && mouseX < mRight && mouseY >= mTop && mouseY < mBottom) {
            currentMonitor := A_Index
            break
        }
    }
    if (currentMonitor = 0)
        return

    nextMonitor := (currentMonitor = 1) ? 2 : 1
    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)
    MouseMove(nLeft + (nRight - nLeft) / 2, nTop + (nBottom - nTop) / 2, 0)
    Click
    ToolTip "🖱️ Monitor Switched"
    SetTimer () => ToolTip(), -120
}

; ==================================================
; [함수 5] Edge 브라우저(특정 사이트) 토글 실행
; ==================================================
OpenEdgeApp(searchTitle, url) {
    global capsComboUsed := true

    ToolTip("🤖 " . searchTitle)
    SetTimer(() => ToolTip(), -300)

    edgeWindows := WinGetList("ahk_exe msedge.exe")

    if (edgeWindows.Length > 0) {
        hwnd := edgeWindows[1]

        if WinActive("ahk_id " . hwnd) {
            WinMinimize("ahk_id " . hwnd)
            return
        }

        if (WinGetMinMax("ahk_id " hwnd) = -1)
            WinRestore("ahk_id " hwnd)

        WinActivate("ahk_id " hwnd)
        WinWaitActive("ahk_id " hwnd, , 0.5)

        if !WinActive("ahk_id " hwnd) {
            WinSetAlwaysOnTop(1, "ahk_id " hwnd)
            Sleep 50
            WinSetAlwaysOnTop(0, "ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
        }
        return
    }

    Run('msedge.exe --new-window "' . url . '"')
}

; ==================================================
; [함수 6] 언리얼 전용 깔끔한 활성화
; ==================================================
ActivateUnrealClean(searchTitle) {
    if hwnd := WinExist(searchTitle) {
        if (WinGetMinMax("ahk_id " hwnd) = -1)
            WinRestore("ahk_id " hwnd)

        WinActivate("ahk_id " hwnd)
    }
}

; ==================================================
; [함수 7] 개발 환경 판별
; ==================================================
IsDevEnvironment() => (WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") || WinActive("ahk_exe UnrealEditorFortnite-Win64-Shipping.exe") || InStr(WinGetTitle("A"), "Unreal Editor") || WinActive("ahk_class UnrealWindow") || WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe code.exe"))

; ==================================================
; [함수 8] CapsLock 조합 키 처리
; ==================================================
CapsCombo() {
    global capsComboUsed, capsPrev, actionToken
    actionToken += 1          ; 새 동작 시작 → 이전 동작은 모두 무효화

    if (!capsComboUsed) {
        capsComboUsed := true
        SetCapsLockState(capsPrev)
    }
}

; ==================================================
; [함수 9] 마지막 키보드 입력 후 일정 시간 지나면 CapsLock 끄기
; ==================================================
CheckAndTurnOffCapsLock() {
    global capsIdleMs
    if !GetKeyState("CapsLock", "T") {
        SetTimer(CheckAndTurnOffCapsLock, 0)
        return
    }

    if GetKeyState("CapsLock", "P")
        return

    if (A_TimeIdleKeyboard < capsIdleMs)
        return

    SetCapsLockState(false)
    SetTimer(CheckAndTurnOffCapsLock, 0)

    ToolTip("🔒 CapsLock 자동 꺼짐")
    SetTimer(() => ToolTip(), -500)
}