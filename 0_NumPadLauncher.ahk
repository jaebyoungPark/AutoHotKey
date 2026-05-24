#Requires AutoHotkey v2.0

; 스크립트 전역에서 정규표현식(|) 매칭을 기본으로 사용하도록 설정
SetTitleMatchMode("RegEx")

; ==================================================
; [함수 1] 창 활성화 전용 (창 전환 -> 탭 순환 -> 없으면 최소화 완벽 지원)
; ==================================================
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true) {
    static WinIndexes := Map()
    
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1
    
    windows := WinGetList(searchTitle)
    count := windows.Length
    
    ; 1. 창이 아예 없는 경우: 프로그램 실행 또는 URL 오픈
    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            
            ; 새 창이 로딩될 때까지 최대 2초간 대기하며 고유 ID(HWND)를 직접 획득
            if (hwnd := WinWait(searchTitle, , 2)) {

                ; 현재 마우스 커서가 위치한 모니터 좌표 획득
                coords := GetMouseMonitorCoords()

                ; 고유 ID(ahk_id)를 사용하여 에러 원천 차단
                WinMove(coords.X, coords.Y, , , "ahk_id " hwnd)

                ; 고유 ID로 최대화 실행
                WinMaximize("ahk_id " hwnd)
            }
        }
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; ==================================================
    ; 현재 활성 창이 이미 해당 창인 경우
    ; ==================================================
    if (activeHwnd = windows[currentIndex]) {

        if (cycleTabIfSingle) {

            if (count > 1) {

                ; 다음 창 순환
                currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1

            } else {

                ; 현재 탭 제목 저장
                currentTitle := WinGetTitle("A")

                ; 다음 탭
                Send "^{Tab}"

                ; 탭 제목 변경 대기
                Sleep 30

                ; 새 제목
                newTitle := WinGetTitle("A")

                ; 탭 하나뿐이면 최소화
                if (newTitle = currentTitle) {

                    WinMinimize(windows[currentIndex])
                    return
                }

                ; 새 탭이 조건 불일치면 복귀 후 최소화
                if !WinActive(searchTitle) {

                    Send "^+{Tab}"
                    Sleep 20

                    WinMinimize(windows[currentIndex])
                    return
                }

                ; 정상 이동
                return
            }

        } else {

            ; 순환 옵션 꺼져있으면 최소화
            WinMinimize(windows[currentIndex])
            return
        }
    }

    ; ==================================================
    ; 최소화 상태면 복구 후 활성화
    ; ==================================================
    try {

        if (WinGetMinMax(windows[currentIndex]) = -1)
            WinRestore(windows[currentIndex])

        WinActivate(windows[currentIndex])

        WinIndexes[searchTitle] := currentIndex
    }
}

; ==================================================
; [함수 2] 사이트 전용 (짧게: 전환 / 길게: 새 탭 추가)
; ==================================================
OpenSite(keyName, searchTitle, url) {

    ; 0.27초 기준
    if KeyWait(keyName, "T0.27") {

        ActivateOrCycleEx(
            searchTitle . " ahk_exe chrome.exe",
            'chrome.exe --new-window "' . url . '"',
            true
        )

    } else {

        ; 길게 누름 = 새 탭
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

; ==================================================
; [함수 3] 현재 마우스 위치 모니터 좌표 구하기
; ==================================================
GetMouseMonitorCoords() {

    MouseGetPos(&mouseX, &mouseY)

    monitorCount := MonitorGetCount()

    Loop monitorCount {

        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)

        if (mouseX >= Left && mouseX <= Right
         && mouseY >= Top  && mouseY <= Bottom) {

            return {X: Left, Y: Top}
        }
    }

    ; fallback
    MonitorGet(1, &Left, &Top)

    return {X: Left, Y: Top}
}

; ==================================================
; [함수 4] 듀얼 모니터 마우스 순간이동 및 클릭 공통 로직
; ==================================================
MoveMouseToOtherMonitor() {
    monitorCount := MonitorGetCount()

    ; 듀얼 모니터가 아니면 작동 안 함
    if (monitorCount < 2)
        return

    CoordMode("Mouse", "Screen")
    MouseGetPos &mouseX, &mouseY
    currentMonitor := 0

    ; 현재 마우스가 위치한 모니터 탐색
    Loop monitorCount {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        if (mouseX >= mLeft && mouseX < mRight && mouseY >= mTop && mouseY < mBottom) {
            currentMonitor := A_Index
            break
        }
    }

    if (currentMonitor = 0)
        return

    ; 반대편 모니터 결정 (1번이면 2번으로, 2번이면 1번으로)
    if (currentMonitor = 1)
        nextMonitor := 2
    else
        nextMonitor := 1

    ; 대상 모니터 영역 정보 획득
    MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

    ; 정중앙 좌표 계산
    targetX := nLeft + (nRight - nLeft) / 2
    targetY := nTop + (nBottom - nTop) / 2

    ; 순간이동 후 클릭하여 창 활성화
    MouseMove(targetX, targetY, 0)
    Click

    ; 화면에 안내 피드백 출력
    ToolTip "🖱️ Monitor Switched"
    SetTimer () => ToolTip(), -120
}


; ==================================================
; 단축키 설정 영역
; ==================================================

; -------------------------
; 프로그램
; -------------------------
; 클래스 이름을 사용하여 DebugGame 등 모든 빌드 구성을 한 번에 매칭
Numpad1:: ActivateOrCycleEx("ahk_class UnrealWindow", , false)

Numpad2:: ActivateOrCycleEx(
    "ahk_exe devenv.exe",
    "devenv.exe",
    false
)

; -------------------------
; 사진 / 메모장
; -------------------------
Numpad8::
{
    ; 0.27초 기준
    if KeyWait("Numpad8", "T0.27") {

        ActivateOrCycleEx(
            "ahk_exe Photos.exe",
            "ms-photos:",
            true
        )

    } else {

        ; 이전 탭/세션 복원을 위해 윈도우 11 메모장 앱 고유의 쉘 주소로 실행
        ActivateOrCycleEx(
            "ahk_exe notepad.exe",
            "shell:AppsFolder\Microsoft.WindowsNotepad_8wekyb3d8bbwe!App",
            true
        )

        KeyWait("Numpad8")
    }
}

; -------------------------
; 웹사이트
; -------------------------
Numpad3:: OpenSite(
    "Numpad3",
    "Udemy",
    "https://www.udemy.com/home/my-courses/learning/"
)

Numpad4:: OpenSite(
    "Numpad4",
    "치지직|CHZZK",
    "https://chzzk.naver.com/"
)

Numpad5:: OpenSite(
    "Numpad5",
    "SOOP|아프리카|Afreeca",
    "https://www.sooplive.com/"
)

Numpad6:: OpenSite(
    "Numpad6",
    "YouTube",
    "https://www.youtube.com/"
)

Numpad7:: OpenSite(
    "Numpad7",
    "NAVER|네이버",
    "https://www.naver.com/"
)

NumpadAdd:: OpenSite(
    "NumpadAdd",
    "Claude",
    "https://claude.ai/"
)

NumpadSub:: OpenSite(
    "NumpadSub",
    "Gemini",
    "https://gemini.google.com/"
)

NumLock:: OpenSite(
    "NumLock",
    "dcinside|디시인사이드|노산",
    "https://gall.dcinside.com/mgallery/board/lists/?id=nobirth"
)

; -------------------------
; 새 창
; -------------------------
Numpad9::
{
    ; 0.27초 기준
    if KeyWait("Numpad9", "T0.27") {

        ; 크롬 새 창
        Run 'chrome.exe --new-window'

    } else {

        ; 길게 누르면 다음
        OpenSite(
            "Numpad9",
            "Daum|다음",
            "https://www.daum.net/"
        )

        KeyWait("Numpad9")
    }
}

; -------------------------
; 최소화 / 전체화면
; -------------------------
Numpad0::
{
    ; 0.27초 기준
    if KeyWait("Numpad0", "T0.27") {

        WinMinimize("A")

    } else {

        Send "{F11}"

        KeyWait("Numpad0")
    }
}


; ==================================================
; 언리얼 / 개발 환경 판별
; ==================================================
IsDevEnvironment()
{
    ; Unreal + Visual Studio
    return (
           WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || InStr(WinGetTitle("A"), "Unreal Editor")
        || WinActive("ahk_class UnrealWindow")

        || WinActive("ahk_exe devenv.exe")
    )
}
; ==================================================
; 이전 탭 / 마우스 모니터 이동 (NumpadDiv: 키패드 /)
; ==================================================
NumpadDiv::
{
    ; 개발 환경이면 즉시 모니터 이동
    if IsDevEnvironment() {

        ToolTip "🟣 Dev Mode : Mouse Teleport (/)"
        SetTimer () => ToolTip(), -300

        MoveMouseToOtherMonitor()
        return
    }

    ; 일반 환경
    if KeyWait("NumpadDiv", "T0.27") {

        ; 짧게 누름: 이전 탭
        Send "^+{Tab}"

    } else {

        ; 길게 누름: 모니터 이동
        MoveMouseToOtherMonitor()
        KeyWait("NumpadDiv")
    }
}

; ==================================================
; 다음 탭 (NumpadMult: 키패드 *)
; ==================================================
NumpadMult::
{
    ; 언리얼 환경 예외 처리
    if WinActive("ahk_class UnrealWindow") {
        MoveMouseToOtherMonitor()
        return
    }

    ; 일반 환경: 다음 탭
    Send "^{Tab}"
}


; ==================================================
; 숫자 키 매핑
; ==================================================

; ==================================================
; 1 → Unreal Engine
; ==================================================
1:: ActivateOrCycleEx(
    "ahk_class UnrealWindow",
    ,
    false
)

; ==================================================
; 2 → Visual Studio
; ==================================================
2:: ActivateOrCycleEx(
    "ahk_exe devenv.exe",
    "devenv.exe",
    false
)

; ==================================================
; 3 → Udemy
; ==================================================
3:: OpenSite(
    "3",
    "Udemy",
    "https://www.udemy.com/home/my-courses/learning/"
)

; ==================================================
; 4 → CHZZK
; ==================================================
4:: OpenSite(
    "4",
    "치지직|CHZZK",
    "https://chzzk.naver.com/"
)

; ==================================================
; 5 → SOOP
; ==================================================
5:: OpenSite(
    "5",
    "SOOP|아프리카|Afreeca",
    "https://www.sooplive.com/"
)

; ==================================================
; 6 → YouTube
; ==================================================
6:: OpenSite(
    "6",
    "YouTube",
    "https://www.youtube.com/"
)

; ==================================================
; 7 → NAVER
; ==================================================
7:: OpenSite(
    "7",
    "NAVER|네이버",
    "https://www.naver.com/"
)

; ==================================================
; 8 → Claude
; ==================================================
8:: OpenSite(
    "8",
    "Claude",
    "https://claude.ai/"
)

; ==================================================
; 9 → DCInside
; ==================================================
9:: OpenSite(
    "9",
    "dcinside|디시인사이드|노산",
    "https://gall.dcinside.com/mgallery/board/lists/?id=nobirth"
)