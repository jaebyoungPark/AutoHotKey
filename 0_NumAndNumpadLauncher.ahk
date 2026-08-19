#Requires AutoHotkey v2.0
SetTitleMatchMode("RegEx")

; [함수 1] 창 활성화 / 순환 / 최소화 (실패 알림 및 강제 활성화 강화 버전)
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true) {
    static WinIndexes := Map()
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1
    
    windows := WinGetList(searchTitle)
    count := windows.Length

    ; ----------------------------------------------------
    ; CASE 1: 창이 하나도 안 켜져 있는 경우 (실행 시도)
    ; ----------------------------------------------------
    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            ; 2.5초 동안 창이 뜨길 기다림
            if WinWait(searchTitle, , 2.5) {
                if hwnd := WinExist(searchTitle) {
                    coords := GetMouseMonitorCoords()
                    try WinMove(coords.X, coords.Y, , , "ahk_id " hwnd)
                    try WinMaximize("ahk_id " hwnd)
                    return
                }
            }
        }
        
        ; ❌ [실패 알림 1] 프로그램 실행 명령을 내렸으나 창 감지에 실패한 경우
        ToolTip("⚠️ 창을 찾을 수 없거나 실행에 실패했습니다.`n조건: " . searchTitle)
        SetTimer(() => ToolTip(), -3000) ; 3초 후 툴팁 삭제
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; ----------------------------------------------------
    ; CASE 2: 이미 해당 창이 활성화되어 있는 경우
    ; ----------------------------------------------------
    if (activeHwnd = windows[currentIndex]) {
        if (count > 1) {
            ; 창이 여러 개일 경우: 다음 창으로 인덱스 이동
            currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
        } else if (cycleTabIfSingle) {
            ; 창이 1개이고 크롬 등 웹브라우저 탭 순환 모드일 때
            currentTitle := WinGetTitle("A")
            Send "^{Tab}"
            Sleep 30
            if (WinGetTitle("A") = currentTitle || !WinActive(searchTitle)) {
                if !WinActive(searchTitle) {
                    Send "^+{Tab}"
                    Sleep 20
                }
                WinMinimize(windows[currentIndex])
                return
            }
            return
        } else {
            ; 창이 1개이고 일반 프로그램일 때: 최소화
            WinMinimize(windows[currentIndex])
            return
        }
    }

    ; ----------------------------------------------------
    ; CASE 3: 창은 있으나 뒤에 숨어있는 경우 (활성화 시도)
    ; ----------------------------------------------------
    try {
        targetHwnd := windows[currentIndex]
        
        if (WinGetMinMax(targetHwnd) = -1)
            WinRestore(targetHwnd)
            
        WinActivate(targetHwnd)
        WinWaitActive(targetHwnd, , 0.2) ; 0.2초간 활성화 대기
        
        ; 💥 [강제 우회] 0.2초 대기 후에도 활성화가 안 되었다면 (윈도우 먹통 버그 발생 시)
        if (!WinActive(targetHwnd)) {
            WinMinimize(targetHwnd)
            Sleep 50
            WinRestore(targetHwnd)
            WinActivate(targetHwnd)
            
            ; 항상 위 레이어로 강제 견인 후 해제
            WinSetAlwaysOnTop(1, targetHwnd)
            WinSetAlwaysOnTop(0, targetHwnd)
            WinWaitActive(targetHwnd, , 0.2)
        }
        
        ; ❌ [실패 알림 2] 창이 존재함에도 OS 포커스 잠금 등으로 활성화에 최종 실패한 경우
        if (!WinActive(targetHwnd)) {
            ToolTip("❌ 창 활성화 실패 (프로세스가 응답하지 않음)")
            SetTimer(() => ToolTip(), -2000)
        }

        if WinActive("ahk_exe chrome.exe") {
            Sleep 50
            WinGetPos(&X, &Y, &W, &H, targetHwnd)
            WinMove(X, Y, W, H, targetHwnd)
        }
        WinIndexes[searchTitle] := currentIndex
    }
}

; [함수 2] 사이트 열기 (짧게: 전환 / 길게: 새 탭)
OpenSite(keyName, searchTitle, url) {
    if KeyWait(keyName, "T0.27") {
        ActivateOrCycleEx(searchTitle . " ahk_exe chrome.exe", 'chrome.exe --new-window "' . url . '"', true)
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

; 개발 환경 판별 함수
IsDevEnvironment() => (WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") || WinActive("ahk_exe UnrealEditorFortnite-Win64-Shipping.exe") || InStr(WinGetTitle("A"), "Unreal Editor") || WinActive("ahk_class UnrealWindow") || WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe code.exe"))

; ==================================================
; 단축키 매핑 (프로그램 및 웹사이트)
; ==================================================

; --- 블렌더 단축키 ---
Numpad1:: {
    if KeyWait("Numpad1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", true)
    } else {
        Run("blender.exe")
        KeyWait("Numpad1")
    }
}

1:: {
    if KeyWait("1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", true)
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
Numpad3:: OpenSite("Numpad3", "Inflearn|인프런", "https://www.inflearn.com/?srsltid=AfmBOor_NQzhHrhhBLbbRitXyQbb_xxZcKF16V-5bD9RLUKl0hvDbPo_")
3::        OpenSite("3", "Inflearn|인프런", "https://www.inflearn.com/?srsltid=AfmBOor_NQzhHrhhBLbbRitXyQbb_xxZcKF16V-5bD9RLUKl0hvDbPo_")
;==========================================

Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
4::        OpenSite("4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
5::        OpenSite("5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
6::        OpenSite("6", "YouTube", "https://www.youtube.com/")
Numpad7:: OpenSite("Numpad7", "GOOGLE|구글", "https://www.google.com/")
7::        OpenSite("7", "GOOGLE|구글", "https://www.google.com/")

; --- 사진 / 메모장 복합 키 ---
Numpad8:: {
    if KeyWait("Numpad8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
        KeyWait("Numpad8")
}
8:: {
    if KeyWait("8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
        KeyWait("8")
}

Numpad9:: CenterMouseAndExecuteMacro()
9::        CenterMouseAndExecuteMacro()

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

; NumpadDiv 복합 기능
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
; ==================================================

global capsComboUsed := false

*CapsLock::
{
    global capsComboUsed := false
    KeyWait("CapsLock")
    
    if (!capsComboUsed) {
        Send("{Blind}{CapsLock}")
    }
}

#HotIf GetKeyState("CapsLock", "P")

a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z:: {
    global capsComboUsed := true
    SetCapsLockState(!GetKeyState("CapsLock", "T"))
    SendInput("{Blind}" . A_ThisHotkey)
}

1::
Numpad1:: {
    global capsComboUsed := true
    ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", false)
}

2::
Numpad2:: {
    global capsComboUsed := true
    VSCodeSmartLauncher()
}

3::
Numpad3:: {
    global capsComboUsed := true
    OpenSite("3", "친절한 블렌더", "https://www.inflearn.com/...")
}

4::
Numpad4:: {
    global capsComboUsed := true
    OpenSite("4", "치지직|CHZZK", "https://chzzk.naver.com/")
}

5::
Numpad5:: {
    global capsComboUsed := true
    OpenSite("5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
}

6::
Numpad6:: {
    global capsComboUsed := true
    OpenSite("6", "YouTube", "https://www.youtube.com/")
}

7::
Numpad7:: {
    global capsComboUsed := true
    OpenSite("7", "GOOGLE|구글", "https://www.google.com/")
}

8::
Numpad8:: {
    global capsComboUsed := true
    OpenSite("8", "Photos", "ms-photos:")
}

9::
Numpad9:: {
    global capsComboUsed := true
    CenterMouseAndExecuteMacro()
}

0::
Numpad0:: {
    global capsComboUsed := true
    WinMinimize("A")
}

#HotIf