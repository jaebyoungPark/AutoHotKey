#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode("RegEx")

; [함수 1] 창 활성화 / 순환 / 최소화
; 창 1개: 탭 이동 없이 활성 상태면 최소화, 아니면 활성화
; 창 여러 개: 활성 창 다음 창으로 순환 (탭 순회 없음)
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := false) {
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
                if hwnd := WinExist(searchTitle) {
                    coords := GetMouseMonitorCoords()
                    try WinMove(coords.X, coords.Y, , , "ahk_id " hwnd)
                    try WinMaximize("ahk_id " hwnd)
                    return
                }
            }
        }

        ToolTip("⚠️ 창을 찾을 수 없거나 실행에 실패했습니다.`n조건: " . searchTitle)
        SetTimer(() => ToolTip(), -3000)
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; 현재 활성 창이 매칭 목록의 몇 번째인지 찾기 (0이면 매칭 창이 활성 상태가 아님)
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
            ; 창이 여러 개: 활성 창의 다음 창으로 이동 (창 단위 순회만)
            currentIndex := (activeIdx >= count) ? 1 : activeIdx + 1
        } else {
            ; 창이 1개: 탭 이동 없이 바로 최소화
            WinMinimize(windows[1])
            return
        }
    }

    ; CASE 3: 대상 창 활성화
    targetHwnd := windows[currentIndex]

    try {
        ; 최소화 상태(-1)라면 먼저 정상 크기로 복원
        if (WinGetMinMax("ahk_id " targetHwnd) = -1)
            WinRestore("ahk_id " targetHwnd)

        WinActivate("ahk_id " targetHwnd)
        WinWaitActive("ahk_id " targetHwnd, , 0.3)

        if (!WinActive("ahk_id " targetHwnd)) {
            WinSetAlwaysOnTop(1, "ahk_id " targetHwnd)
            Sleep 30
            WinSetAlwaysOnTop(0, "ahk_id " targetHwnd)
            WinActivate("ahk_id " targetHwnd)
        }

; 크롬 창 복원 후 화면이 까맣게 변하는 현상 방지 (WinAPI 강제 재렌더링 방식)
if WinActive("ahk_exe chrome.exe") {
    WinActivate("ahk_class Shell_TrayWnd")
    WinActivate("ahk_id " targetHwnd)
}

        WinIndexes[searchTitle] := currentIndex
    } catch as err {
        ToolTip("⚠️ 창 활성화 중 오류 발생: " . err.Message)
        SetTimer(() => ToolTip(), -3000)
    }
}   ; ← ActivateOrCycleEx 함수 닫기 (이게 빠져 있었음)

; [함수 2] 사이트 열기 (짧게: 전환 / 길게: 새 탭)
OpenSite(keyName, searchTitle, url) {
    if KeyWait(keyName, "T0.27") {
        ActivateOrCycleEx(searchTitle . " ahk_exe chrome.exe", 'chrome.exe --new-window "' . url . '"', false)
    } else {
        if WinActive("ahk_exe chrome.exe") {
            Send "^t"
            Sleep 150
            SendText url
            Send "{Enter}"
        } else {
            Run 'chrome.exe "' . url . '"'
        }
        KeyWait(keyName)
    }
}

; [함수 3] 현재 마우스 위치 모니터 좌표 구하기
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

; [함수 4] 듀얼 모니터 마우스 순간이동
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

; [함수] Edge 브라우저(특정 사이트) 토글 실행 함수
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


; 개발 환경 판별 함수
IsDevEnvironment() => (WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") || WinActive("ahk_exe UnrealEditorFortnite-Win64-Shipping.exe") || InStr(WinGetTitle("A"), "Unreal Editor") || WinActive("ahk_class UnrealWindow") || WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe code.exe"))

; ==================================================
; 단축키 매핑 (프로그램 및 웹사이트)
; ==================================================

; --- 블렌더 단축키 ---
Numpad1:: {
    if KeyWait("Numpad1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", false)
    } else {
        Run("blender.exe")
        KeyWait("Numpad1")
    }
}

1:: {
    if KeyWait("1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", false)
    } else {
        Run("blender.exe")
        KeyWait("1")
    }
}

; --- VS Code 스마트 러처 ---
Numpad2:: VSCodeSmartLauncher()
2::        VSCodeSmartLauncher()

VSCodeSmartLauncher() {
    if ProcessExist("Code.exe") || ProcessExist("code.exe") {
        if hwnd := WinExist("ahk_exe Code.exe") {
            if (WinGetMinMax("ahk_id " hwnd) = -1)
                WinRestore("ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
            return
        }
    }
    Run("cmd.exe /c start /b code", , "Hide")
}

;======[3, Numpad3] 인프런 사이트=========
;Numpad3:: OpenSite("Numpad3", "Inflearn|인프런", "https://www.inflearn.com/?srsltid=AfmBOor_NQzhHrhhBLbbRitXyQbb_xxZcKF16V-5bD9RLUKl0hvDbPo_")
;3::        OpenSite("3", "Inflearn|인프런", "https://www.inflearn.com/?srsltid=AfmBOor_NQzhHrhhBLbbRitXyQbb_xxZcKF16V-5bD9RLUKl0hvDbPo_")
;==========================================
;======[3, Numpad3] 콜로소 사이트=========
;Numpad3:: OpenSite("Numpad3", "Coloso|콜로소", "https://coloso.co.kr/classroom/236440")
;3::        OpenSite("3", "Coloso|콜로소", "https://coloso.co.kr/classroom/236440")
;==========================================
;======[3, Numpad3] 유데미 사이트=========
Numpad3:: OpenSite("Numpad3", "Udemy|유데미", "https://www.udemy.com/")   ; keyName "Numpad4" → "Numpad3" 오타 수정
3::        OpenSite("3", "Udemy|유데미", "https://www.udemy.com/")
;==========================================

Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
4::        OpenSite("4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
5::        OpenSite("5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
6::        OpenSite("6", "YouTube", "https://www.youtube.com/")
/*
Numpad7:: OpenSite("Numpad7", "GOOGLE|구글", "https://www.google.com/")
7::        OpenSite("7", "GOOGLE|구글", "https://www.google.com/")
*/

; --- [새로운 Numpad7 동작: 왼쪽 방향키] ---
Numpad7:: {
    Send("{Left}")
ToolTip("◀")
    SetTimer(() => ToolTip(), -200)
}
7:: {
    Send("{Left}")
ToolTip("◀")
    SetTimer(() => ToolTip(), -200)
}



; --- 사진 / 메모장 복합 키 ---
;Numpad8:: {
;    if KeyWait("Numpad8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
;        KeyWait("Numpad8")
;}
;8:: {
;    if KeyWait("8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
;        KeyWait("8")
;}

8::
Numpad8:: {
    global capsComboUsed := true

    ; 원하시는 URL과 이름을 여기에 넣어주세요 (예: ChatGPT)
    OpenEdgeApp("ChatGPT (Edge)", "https://chatgpt.com/")
}
/*
Numpad9:: CenterMouseAndExecuteMacro()
9::        CenterMouseAndExecuteMacro()
*/
; --- [새로운 Numpad9 동작: 오른쪽 방향키] ---
Numpad9:: {
    Send("{Right}")
ToolTip("▶")
    SetTimer(() => ToolTip(), -200)
}
9:: {
    Send("{Right}")
ToolTip("▶")
    SetTimer(() => ToolTip(), -200)
}


NumLock:: OpenSite("9", "Epic Games Documentation|Epic Developer Community", "https://dev.epicgames.com/documentation/")

$NumpadAdd::
{
    if KeyWait("NumpadAdd", "T0.2") {
        ; 단독 입력 시 동작
    } else {
        KeyWait("NumpadAdd")
    }
}
#HotIf GetKeyState("NumpadAdd", "P")
Numpad0::Send "{Numpad0}"
Numpad1::Send "{Numpad1}"
Numpad2::Send "{Numpad2}"
Numpad3::Send "{Numpad3}"
Numpad4::Send "{Numpad4}"
Numpad5::Send "{Numpad5}"
Numpad6::Send "{Numpad6}"
Numpad7::Send "{Numpad7}"
Numpad8::Send "{Numpad8}"
Numpad9::Send "{Numpad9}"
#HotIf

; --- F3 단축키 ---
$F3:: {
    if WinActive("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass") {
        Send("{F3}")
    } else {
        OpenSite("F3", "Claude", "https://claude.ai/")
    }
}
NumpadSub:: OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")
F4::         OpenSite("F4", "Gemini", "https://gemini.google.com/")

; 최소화 / 전체화면
Numpad0:: {
    if KeyWait("Numpad0", "T0.27")
        WinMinimize("A")
    else
        Send("{F11}"), KeyWait("Numpad0")
}

; ==================================================
; NumpadDiv (/) 키 복합 기능 로직
; ==================================================

/*
; [요청하신 기존 로직 주석 처리]
NumpadDiv:: {
    if WinActive("ahk_exe ChatGPT.exe")
        return Send("{Up 2}")
    if WinActive("ahk_exe Photos.exe")
        return Send("{Left}")
    if IsDevEnvironment() {
        ToolTip("🟣 Dev Mode : Mouse Teleport (/)"), SetTimer(() => ToolTip(), -300)
        return MoveMouseToOtherMonitor()
    }
    if KeyWait("NumpadDiv", "T0.27")
        Send "^+{Tab}"
    else
        MoveMouseToOtherMonitor(), KeyWait("NumpadDiv")
}
*/

; [복제 및 HandleCtrlShiftA 호출로 대체된 NumpadDiv]
$NumpadDiv:: HandleCtrlShiftA() ;OpenBookmark.ahk 에 있음



; NumpadMult 복합 기능
NumpadMult:: {
    if WinActive("ahk_exe ChatGPT.exe")
        return Send("{Down 2}")
    if WinActive("ahk_exe Photos.exe")
        return Send("{Right}")
    if WinActive("ahk_class UnrealWindow")
        return MoveMouseToOtherMonitor()
    Send "^{Tab}"
}

; ==================================================
; [CapsLock + 알파벳/숫자 단축키 설정]
; 누르는 즉시 대소문자 토글, 조합 키를 쓰면 누르기 전 상태로 복구
; ==================================================
global capsComboUsed := false
global capsHeld := false
global capsPrev := false

; 조합 키 사용 시 호출: 홀드당 한 번만 원래 상태로 복구
CapsCombo() {
    global capsComboUsed, capsPrev
    if (!capsComboUsed) {
        capsComboUsed := true
        SetCapsLockState(capsPrev)
    }
}

*CapsLock:: {
    global capsComboUsed, capsHeld, capsPrev
    if capsHeld          ; 키 반복 입력 무시
        return
    capsHeld := true
    capsComboUsed := false
    capsPrev := GetKeyState("CapsLock", "T")
    SetCapsLockState(!capsPrev)     ; 누르는 즉시 토글

; ⏱️ CapsLock이 눌릴 때마다 기존 타이머를 초기화
    SetTimer(CheckAndTurnOffCapsLock, 0)
}

*CapsLock up:: {
    global capsHeld
    capsHeld := false

    ; CapsLock을 뗀 시점부터 키보드 입력 유휴 시간 확인
    SetTimer(CheckAndTurnOffCapsLock, 250)
}

; 마지막 키보드 입력으로부터 5초간 입력이 없을 때 CapsLock 끄기
CheckAndTurnOffCapsLock() {
    if !GetKeyState("CapsLock", "T") {
        SetTimer(CheckAndTurnOffCapsLock, 0)
        return
    }

    if GetKeyState("CapsLock", "P")
        return

    if (A_TimeIdleKeyboard < 5000)
        return

    SetCapsLockState(false)
    SetTimer(CheckAndTurnOffCapsLock, 0)

    ToolTip("🔒 CapsLock 자동 꺼짐 (키보드 입력 5초 없음)")
    SetTimer(() => ToolTip(), -1500)
}


#HotIf GetKeyState("CapsLock", "P")

1::
Numpad1:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_exe i)blender.exe ahk_class GHOST_WindowClass", "blender.exe", false)

}

;2::
;Numpad2:: {
;    CapsCombo()
;    OpenSite("2", "Udemy|유데미", "https://www.udemy.com/")
;}

2::
Numpad2:: {
    CapsCombo()

    if WinExist("ahk_exe UnrealEditor.exe")
        WinActivate("ahk_exe UnrealEditor.exe")
}

3::
Numpad3:: {
    CapsCombo()
    OpenSite("3", "YouTube", "https://www.youtube.com/")
}

4::
Numpad4:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", false)
}

5::
Numpad5:: {
    CapsCombo()
    OpenSite("5", "치지직|CHZZK", "https://chzzk.naver.com/")
}


6::
Numpad6:: {
    CapsCombo()
    OpenSite("6", "YouTube", "https://www.youtube.com/")
}

7::
Numpad7:: {
    CapsCombo()
    OpenSite("7", "GOOGLE|구글", "https://www.google.com/")
}

8::
Numpad8:: {
    CapsCombo()
    OpenSite("8", "Photos", "ms-photos:")
}

9::
Numpad9:: {
    CapsCombo()
    CenterMouseAndExecuteMacro()
}

0::
Numpad0:: {
    CapsCombo()
    WinMinimize("A")
}

F1:: {
    CapsCombo()
    ToolTip("🦴 RigPractice.blend")
    SetTimer(() => ToolTip(), -1000)
    Run('"E:\Programs\blender.exe" "G:\AllBlender\RigPractice.blend"')
}

SC029:: {
    CapsCombo()
    ToolTip("🤖 ChatGPT (Edge)")
    SetTimer(() => ToolTip(), -300)

    edgeWindows := WinGetList("ahk_exe msedge.exe")
    if (edgeWindows.Length > 0) {
        hwnd := edgeWindows[1]
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
    Run('msedge.exe --new-window "https://chatgpt.com/"')
}

#HotIf