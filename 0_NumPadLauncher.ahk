#Requires AutoHotkey v2.0

; ==================================================
; 창 활성화 통합 함수 (중복 실행 방지 강화판)
; ==================================================
ActivateOnly(searchTitle, runCommand := "") {
    ; 검색 모드를 2(포함)로 설정하여 가장 유연하게 창을 찾음
    prevMode := SetTitleMatchMode(2)
    
    ; 1. 해당 타이틀을 가진 모든 창의 ID(Hwnd) 목록을 가져옴
    windows := WinGetList(searchTitle)
    
    ; 2. 창이 하나도 없다면 새로 실행
    if (windows.Length = 0) {
        if (runCommand != "")
            Run(runCommand)
        SetTitleMatchMode(prevMode)
        return
    }

    ; 3. 현재 활성화된 창이 목록에 있는지 확인
    activeHwnd := WinActive("A")
    isAlreadyActive := false
    for hwnd in windows {
        if (activeHwnd = hwnd) {
            isAlreadyActive := true
            break
        }
    }

    ; 4. 이미 활성화 상태라면 아무것도 하지 않고 종료
    if (isAlreadyActive) {
        SetTitleMatchMode(prevMode)
        return
    }

    ; 5. 창은 있지만 활성화 상태가 아니라면 가장 최근 창을 활성화
    try {
        WinActivate(windows[1])
    }
    
    SetTitleMatchMode(prevMode)
}

; ==================================================
; 단축키 설정 (모두 "이미 켜져있으면 가만히" 모드)
; ==================================================

; 넘패드 1 → 언리얼 엔진
Numpad1:: ActivateOnly("Unreal Editor")

; 넘패드 2 → Visual Studio
Numpad2:: ActivateOnly("ahk_exe devenv.exe", "devenv.exe")

; 넘패드 3 → Udemy
Numpad3:: ActivateOnly("Udemy ahk_exe chrome.exe", 'chrome.exe --new-window "https://www.udemy.com/"')

; 넘패드 4 → 치지직 (RegEx 대신 포함어 검색으로 안정성 확보)
Numpad4:: ActivateOnly("치지직 ahk_exe chrome.exe", 'chrome.exe --new-window "https://chzzk.naver.com/"')

; 넘패드 5 → SOOP (숲티비)
Numpad5:: ActivateOnly("SOOP ahk_exe chrome.exe", 'chrome.exe --new-window "https://www.sooplive.com/"')

; 넘패드 6 → YouTube
Numpad6:: ActivateOnly("YouTube ahk_exe chrome.exe", 'chrome.exe --new-window "https://www.youtube.com/"')

; 넘패드 7 → 네이버
Numpad7:: ActivateOnly("NAVER ahk_exe chrome.exe", 'chrome.exe --new-window "https://www.naver.com/"')

; 넘패드 8 → 메모장
Numpad8:: ActivateOnly("ahk_exe notepad.exe", "notepad.exe")

; 넘패드 9 → 크롬 새 창 (이건 예외적으로 항상 새로 띄움)
Numpad9:: Run "chrome.exe --new-window"

; 넘패드 + (클로드)
NumpadAdd:: ActivateOnly("Claude ahk_exe chrome.exe", 'chrome.exe --new-window "https://claude.ai/"')

; 넘패드 - (제미나이)
NumpadSub:: ActivateOnly("Gemini ahk_exe chrome.exe", 'chrome.exe --new-window "https://gemini.google.com/"')

; 넘패드 / , * (탭 이동은 그대로 유지)
NumpadDiv:: Send "^+{Tab}"
NumpadMult:: Send "^{Tab}"