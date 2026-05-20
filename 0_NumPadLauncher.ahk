#Requires AutoHotkey v2.0

; ==================================================
; [함수 1] 창 활성화 전용 (창 전환 -> 탭 순환 -> 없으면 최소화 완벽 지원)
; ==================================================
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true) {
    static WinIndexes := Map()
    
    ; 정규표현식 모드로 설정하여 복합 조건(|) 완벽 매칭
    prevMode := SetTitleMatchMode("RegEx")
    
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1
    
    windows := WinGetList(searchTitle)
    count := windows.Length
    
    ; 1. 창이 아예 없는 경우: 프로그램 실행 또는 URL 오픈
    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            
            ; 새 창이 로딩될 때까지 최대 2초간 대기
            if WinWait(searchTitle, , 2) {

                ; 현재 마우스 커서가 위치한 모니터 좌표 획득
                coords := GetMouseMonitorCoords()

                ; 해당 모니터로 창 이동
                WinMove(coords.X, coords.Y, , , searchTitle)

                ; 최대화
                WinMaximize(searchTitle)
            }
        }

        SetTitleMatchMode(prevMode)
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

                    SetTitleMatchMode(prevMode)
                    return
                }

                ; 새 탭이 조건 불일치면 복귀 후 최소화
                if !WinActive(searchTitle) {

                    Send "^+{Tab}"
                    Sleep 20

                    WinMinimize(windows[currentIndex])

                    SetTitleMatchMode(prevMode)
                    return
                }

                ; 정상 이동
                SetTitleMatchMode(prevMode)
                return
            }

        } else {

            ; 순환 옵션 꺼져있으면 최소화
            WinMinimize(windows[currentIndex])

            SetTitleMatchMode(prevMode)
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

    SetTitleMatchMode(prevMode)
}

; ==================================================
; [함수 2] 사이트 전용
; 짧게: 전환
; 길게: 새 탭 추가
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
; 현재 마우스 위치 모니터 좌표 구하기
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
; 단축키
; ==================================================

; -------------------------
; 프로그램
; -------------------------
Numpad1:: ActivateOrCycleEx("Unreal Editor", , false)

Numpad2:: ActivateOrCycleEx(
    "ahk_exe devenv.exe",
    "devenv.exe",
    false
)

; -------------------------
; 사진 / 메모장 (수정완료)
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

        ; [변경점] 이전 탭/세션 복원을 위해 윈도우 11 메모장 앱 고유의 쉘 주소로 실행합니다.
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

Numpad9:: OpenSite(
    "Numpad9",
    "Daum|다음",
    "https://www.daum.net/"
)

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
; 이전 탭 / 마우스 모니터 이동
; ==================================================
NumpadDiv::
{
    ; 0.27초 기준
    if KeyWait("NumpadDiv", "T0.27") {

        ; 이전 탭
        Send "^+{Tab}"

    } else {

        monitorCount := MonitorGetCount()

        ; 듀얼 모니터 아니면 종료
        if (monitorCount < 2)
            return

        CoordMode("Mouse", "Screen")

        MouseGetPos &mouseX, &mouseY

        currentMonitor := 0

        ; 현재 마우스 모니터 찾기
        Loop monitorCount {

            MonitorGet(
                A_Index,
                &mLeft,
                &mTop,
                &mRight,
                &mBottom
            )

            if (mouseX >= mLeft && mouseX < mRight
             && mouseY >= mTop  && mouseY < mBottom) {

                currentMonitor := A_Index
                break
            }
        }

        if (currentMonitor = 0)
            return

        ; 반대 모니터 결정
        if (currentMonitor = 1)
            nextMonitor := 2
        else
            nextMonitor := 1

        ; 다음 모니터 영역
        MonitorGet(
            nextMonitor,
            &nLeft,
            &nTop,
            &nRight,
            &nBottom
        )

        ; 중앙 좌표
        targetX := nLeft + (nRight - nLeft) / 2
        targetY := nTop + (nBottom - nTop) / 2

        ; 이동
        MouseMove(targetX, targetY, 0)

        ; 클릭
        Click

        ; 표시
        ToolTip "🖱️"

        SetTimer () => ToolTip(), -120

        ; 키 뗄 때까지 대기
        KeyWait("NumpadDiv")
    }
}

; ==================================================
; 다음 탭
; ==================================================
NumpadMult:: Send "^{Tab}"