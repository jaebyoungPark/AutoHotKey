#Requires AutoHotkey v2.0
SetTitleMatchMode("RegEx")

; [함수 1] 창 활성화 / 순환 / 최소화
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true) {
    static WinIndexes := Map()
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1
    
    windows := WinGetList(searchTitle)
    count := windows.Length

    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            if WinWait(searchTitle, , 2) {
                if hwnd := WinExist(searchTitle) {
                    coords := GetMouseMonitorCoords()
                    try WinMove(coords.X, coords.Y, , , "ahk_id " hwnd)
                    try WinMaximize("ahk_id " hwnd)
                }
            }
        }
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    if (activeHwnd = windows[currentIndex]) {
        if (cycleTabIfSingle) {
            if (count > 1) {
                currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
            } else {
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
            }
        } else {
            WinMinimize(windows[currentIndex])
            return
        }
    }

    try {
        if (WinGetMinMax(windows[currentIndex]) = -1)
            WinRestore(windows[currentIndex])
        WinActivate(windows[currentIndex])
        if WinActive("ahk_exe chrome.exe") {
            Sleep 50
            WinGetPos(&X, &Y, &W, &H, windows[currentIndex])
            WinMove(X, Y, W, H, windows[currentIndex])
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
IsDevEnvironment() => (WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe") || InStr(WinGetTitle("A"), "Unreal Editor") || WinActive("ahk_class UnrealWindow") || WinActive("ahk_exe devenv.exe"))

; ==================================================
; 단축키 매핑 (프로그램 및 웹사이트)
; ==================================================
Numpad1:: ActivateOrCycleEx("Unreal Editor ahk_exe i)UnrealEditor", , false)
1::       ActivateOrCycleEx("Unreal Editor ahk_exe i)UnrealEditor", , false)
Numpad2:: ActivateOrCycleEx("ahk_exe devenv.exe", "devenv.exe", false)
2::       ActivateOrCycleEx("ahk_exe devenv.exe", "devenv.exe", false)

Numpad3:: OpenSite("Numpad3", "Udemy", "https://www.udemy.com/home/my-courses/learning/")
3::       OpenSite("3", "Udemy", "https://www.udemy.com/home/my-courses/learning/")
Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
4::       OpenSite("4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
5::       OpenSite("5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
6::       OpenSite("6", "YouTube", "https://www.youtube.com/")
Numpad7:: OpenSite("Numpad7", "GOOGLE|구글", "https://www.google.com/")
7::       OpenSite("7", "GOOGLE|구글", "https://www.google.com/")
9::       OpenSite("9", "Daum 카페|다음 카페|dotax", "https://cafe.daum.net/dotax/Elgq")
NumLock:: OpenSite("9", "Daum 카페|다음 카페|dotax", "https://cafe.daum.net/dotax/Elgq")
NumpadAdd:: OpenSite("NumpadAdd", "Claude", "https://claude.ai/")
F3::        OpenSite("F3", "Claude", "https://claude.ai/")
NumpadSub:: OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")
F4::        OpenSite("F4", "Gemini", "https://gemini.google.com/")

; 사진(짧게) / 메모장(길게) 복합 단축키
Numpad8:: {
    if KeyWait("Numpad8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
        KeyWait("Numpad8")
}
8:: {
    if KeyWait("8", "T0.27") ? ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true) : ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", true)
        KeyWait("8")
}

; 크롬 새 창(짧게) / 다음(길게)
Numpad9:: {
    if KeyWait("Numpad9", "T0.27")
        Run 'chrome.exe --new-window'
    else
        OpenSite("Numpad9", "Daum|다음", "https://www.daum.net/"), KeyWait("Numpad9")
}

; 최소화(짧게) / 전체화면(길게)
Numpad0:: {
    if KeyWait("Numpad0", "T0.27")
        WinMinimize("A")
    else
        Send("{F11}"), KeyWait("Numpad0")
}

; NumpadDiv (나누기 키) 복합 기능
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

; NumpadMult (곱하기 키) 복합 기능
NumpadMult:: {
    if WinActive("ahk_exe ChatGPT.exe")
        return Send("{Down 2}")
    if WinActive("ahk_exe Photos.exe")
        return Send("{Right}")
    if WinActive("ahk_class UnrealWindow")
        return MoveMouseToOtherMonitor()
    Send "^{Tab}"
}