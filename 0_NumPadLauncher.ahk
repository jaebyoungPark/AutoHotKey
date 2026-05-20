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
    
    ; 1. 창이 아예 없는 경우: 프로그램 실행 또는 URL 오픈 (마우스 모니터 감지 + 최대화 기능 추가)
    if (count = 0) {
        if (runCommand != "") {
            Run(runCommand)
            
            ; 새 창이 로딩될 때까지 최대 2초간 대기
            if WinWait(searchTitle, , 2) {
                ; 현재 마우스 커서가 위치한 모니터의 시작 좌표를 획득
                coords := GetMouseMonitorCoords()
                
                ; 마우스가 있는 모니터 위치로 창을 먼저 이동시킨 후
                WinMove(coords.X, coords.Y, , , searchTitle)
                
                ; 💡 해당 모니터에서 창을 즉시 최대화(화면 꽉 차게) 합니다.
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

    ; 2. 현재 창이 이미 매칭되는 창인 경우 (예: 이미 유튜브 창인 경우)
    if (activeHwnd = windows[currentIndex]) {
        if (cycleTabIfSingle) {
            if (count > 1) {
                ; [우선순위 1] 매칭되는 다른 '창(Window)'이 더 있다면 다음 창으로 전환
                currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
            } else {
                ; [우선순위 2] 매칭되는 창이 1개뿐이라면, 크롬 내부의 다른 탭 검사
                currentTitle := WinGetTitle("A")
                
                Send "^{Tab}"
                Sleep 30 ; 💡 요청하신 0.03초(30ms) 대기: 크롬이 탭을 전환하고 타이틀을 바꿀 시간
                
                ; 탭 전환 후의 새로운 제목 획득
                newTitle := WinGetTitle("A")
                
                ; 만약 탭을 전환했는데도 이전 제목과 100% 똑같다면 -> 탭이 하나뿐이라는 뜻
                if (newTitle = currentTitle) {
                    WinMinimize(windows[currentIndex]) ; [우선순위 3] 즉시 최소화
                    SetTitleMatchMode(prevMode)
                    return
                }
                
                ; 탭이 바뀌었는데, 바뀐 새 탭이 유튜브(조건)가 아니라면? 
                ; -> 더 이상 매칭되는 탭이 없으므로 원래 탭으로 복구 후 최소화
                if !WinActive(searchTitle) {
                    Send "^+{Tab}" ; 원래 유튜브 탭으로 복귀
                    Sleep 20
                    WinMinimize(windows[currentIndex]) ; [우선순위 3] 최소화
                    SetTitleMatchMode(prevMode)
                    return
                }
                
                ; 탭이 바뀌었고, 그 새 탭 역시 유튜브라면? 
                ; 정상적으로 다음 유튜브 탭으로 이동한 것이므로 아무것도 하지 않고 유지
                SetTitleMatchMode(prevMode)
                return
            }
        } else {
            ; cycleTabIfSingle 옵션이 false면 즉시 최소화
            WinMinimize(windows[currentIndex])
            SetTitleMatchMode(prevMode)
            return
        }
    }

    ; 3. 활성화하려는 창이 최소화 상태라면 복구(Restore) 후 화면 전면으로 활성화
    try {
        if (WinGetMinMax(windows[currentIndex]) = -1) {
            WinRestore(windows[currentIndex])
        }
        WinActivate(windows[currentIndex])
        WinIndexes[searchTitle] := currentIndex
    }
    
    SetTitleMatchMode(prevMode)
}

; ==================================================
; [함수 2] 사이트 전용 (짧게: 전환 / 길게: 새 탭 추가)
; ==================================================
OpenSite(keyName, searchTitle, url) {
    if KeyWait(keyName, "T0.3") {
        ; 짧게 누름: 브라우저 제목 매칭을 위해 타이틀 뒤에 ahk_exe chrome.exe를 붙여줌
        ActivateOrCycleEx(searchTitle . " ahk_exe chrome.exe", 'chrome.exe --new-window "' . url . '"', true)
    } else {
        ; 길게 누름: 현재 크롬에 새 탭 추가
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
; [추가 헬퍼 함수] 현재 마우스 위치의 모니터 좌표 구하기
; ==================================================
GetMouseMonitorCoords() {
    ; 현재 마우스 X, Y 위치 획득
    MouseGetPos(&mouseX, &mouseY)
    
    ; 연결된 전체 모니터 개수 파악
    monitorCount := MonitorGetCount()
    
    Loop monitorCount {
        ; 각 모니터의 경계면 좌표(Left, Top, Right, Bottom) 획득
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        
        ; 마우스 커서가 해당 모니터의 영역 내에 있는지 판별
        if (mouseX >= Left && mouseX <= Right && mouseY >= Top && mouseY <= Bottom) {
            return {X: Left, Y: Top}
        }
    }
    
    ; 예외 상황 발생 시 기본 1번 모니터 좌표 반환
    MonitorGet(1, &Left, &Top)
    return {X: Left, Y: Top}
}

; ==================================================
; 단축키 설정
; ==================================================

; --- 프로그램 ---
Numpad1:: ActivateOrCycleEx("Unreal Editor", , false)
Numpad2:: ActivateOrCycleEx("ahk_exe devenv.exe", "devenv.exe", false)

Numpad8::
{
    if KeyWait("Numpad8", "T0.3") {
        ActivateOrCycleEx("ahk_exe Photos.exe", "ms-photos:", true)
    } else {
        ActivateOrCycleEx("ahk_exe notepad.exe", "notepad.exe", true)
        KeyWait("Numpad8")
    }
}

; --- 웹사이트 ---
Numpad3:: OpenSite("Numpad3", "Udemy", "https://www.udemy.com/home/my-courses/learning/")
Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
Numpad7:: OpenSite("Numpad7", "NAVER|네이버", "https://www.naver.com/")
NumpadAdd:: OpenSite("NumpadAdd", "Claude", "https://claude.ai/")
NumpadSub:: OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")
NumLock:: OpenSite("NumLock", "dcinside|디시인사이드|노산", "https://gall.dcinside.com/mgallery/board/lists/?id=nobirth")
Numpad9:: OpenSite("Numpad9", "Daum|다음", "https://www.daum.net/")

; --- 최소화 / 전체화면 ---
Numpad0::
{
    if KeyWait("Numpad0", "T0.3") {
        WinMinimize("A")
    } else {
        Send "{F11}"
        KeyWait("Numpad0")
    }
}

; --- 탭 이동 ---
NumpadDiv::
{
    ; 0.3초 이내 떼면 = 짧게 누름
    if KeyWait("NumpadDiv", "T0.3") {

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

        ; 현재 마우스가 있는 모니터 찾기
        Loop monitorCount {

            MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)

            if (mouseX >= mLeft && mouseX < mRight
             && mouseY >= mTop  && mouseY < mBottom) {

                currentMonitor := A_Index
                break
            }
        }

        if (currentMonitor = 0)
            return

        ; 다음 모니터 결정
        if (currentMonitor = 1)
            nextMonitor := 2
        else
            nextMonitor := 1

        ; 다음 모니터 영역 가져오기
        MonitorGet(nextMonitor, &nLeft, &nTop, &nRight, &nBottom)

        ; 중앙 좌표 계산
        targetX := nLeft + (nRight - nLeft) / 2
        targetY := nTop + (nBottom - nTop) / 2

        ; 이동
        MouseMove(targetX, targetY, 0)

        ; 클릭
        Click

        ; 아주 짧게 표시
        ToolTip "🖱️"
        SetTimer () => ToolTip(), -120

        ; 키 뗄 때까지 대기
        KeyWait("NumpadDiv")
    }
}
NumpadMult:: Send "^{Tab}"