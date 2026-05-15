#Requires AutoHotkey v2.0

; ==================================================
; [함수 1] 창 활성화 전용 (정규표현식 지원 + 순환 기능 유지)
; ==================================================
ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true) {
    static WinIndexes := Map()
    
    ; 정규표현식 모드로 설정하여 "치지직|CHZZK" 등을 완벽히 찾음
    prevMode := SetTitleMatchMode("RegEx")
    
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1
    
    windows := WinGetList(searchTitle)
    count := windows.Length
    
    if (count = 0) {
        if (runCommand != "")
            Run(runCommand)
        SetTitleMatchMode(prevMode)
        return
    }

    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; 현재 창이 이미 활성화된 상태라면
    if (activeHwnd = windows[currentIndex]) {
        if (cycleTabIfSingle) {
            if (count = 1) {
                Send "^{Tab}" ; 창이 하나면 탭 전환
            } else {
                currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
            }
        } else {
            ; cycleTabIfSingle가 false면 이미 활성화시 아무것도 안 함
            SetTitleMatchMode(prevMode)
            return
        }
    }

    try {
        WinActivate(windows[currentIndex])
        WinIndexes[searchTitle] := currentIndex
    }
    
    SetTitleMatchMode(prevMode)
}

; ==================================================
; [함수 2] 사이트 전용 (짧게: 전환 / 0.4초: 새 탭 추가)
; ==================================================
OpenSite(keyName, searchTitle, url) {
    if KeyWait(keyName, "T0.4") {
        ; 짧게 누름: 기존의 강력한 검색 로직 호출
        ; 브라우저 제목 매칭을 위해 타이틀 뒤에 ahk_exe chrome.exe를 붙여줌
        ActivateOrCycleEx(searchTitle . " ahk_exe chrome.exe", 'chrome.exe --new-window "' . url . '"', true)
    } else {
        ; 0.4초 이상 누름: 현재 크롬에 새 탭 추가
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
; 단축키 설정
; ==================================================

; --- 프로그램 (이미 활성화시 가만히: false 옵션) ---
Numpad1:: ActivateOrCycleEx("Unreal Editor", , false)
Numpad2:: ActivateOrCycleEx("ahk_exe devenv.exe", "devenv.exe", false)
Numpad8:: ActivateOrCycleEx("ahk_exe notepad.exe", "notepad.exe", true)
Numpad9:: Run "chrome.exe --new-window"

; --- 웹사이트 (짧게: 정규식으로 찾기 / 0.4초: 새 탭) ---
; searchTitle 부분에 정규표현식(|)을 그대로 쓸 수 있습니다.
Numpad3:: OpenSite("Numpad3", "Udemy", "https://www.udemy.com/")
Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
Numpad7:: OpenSite("Numpad7", "NAVER|네이버", "https://www.naver.com/")
NumpadAdd:: OpenSite("NumpadAdd", "Claude", "https://claude.ai/")
NumpadSub:: OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")

; --- 탭 이동 ---
NumpadDiv::  Send "^+{Tab}"
NumpadMult:: Send "^{Tab}"