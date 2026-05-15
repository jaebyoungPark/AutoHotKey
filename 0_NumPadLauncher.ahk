#Requires AutoHotkey v2.0

; ==================================================
; 창 활성화 및 탭 순환 통합 함수
; ==================================================

ActivateOrCycle(searchTitle, exePath := "", runCommand := "") {
    static WinIndexes := Map()
    
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1

    windows := WinGetList(searchTitle)
    count := windows.Length

    ; 1. 창이 없으면 실행
    if (count = 0) {
        if (runCommand != "")
            Run(runCommand)
        return
    }

    ; 2. 인덱스 안전 점검
    if (WinIndexes[searchTitle] > count)
        WinIndexes[searchTitle] := 1

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; 3. 핵심 로직: 현재 창이 이미 활성화된 상태라면?
    if (activeHwnd = windows[currentIndex]) {
        if (count = 1) {
            ; 창이 하나뿐일 때 버튼을 더 누르면 탭 전환 (Ctrl + Tab)
            Send "^{Tab}"
            return 
        } else {
            ; 창이 여러 개면 다음 창으로 인덱스 이동
            currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
        }
    }

    ; 4. 창 활성화
    try {
        WinActivate(windows[currentIndex])
        WinIndexes[searchTitle] := currentIndex
    } catch {
        WinIndexes[searchTitle] := 1
    }
}

; ==================================================
; 단축키 설정 (요청하신 순서대로 재배치)
; ==================================================

; 넘패드 1 → 언리얼 엔진
Numpad1:: ActivateOrCycle("Unreal Editor")

; 넘패드 2 → Visual Studio
Numpad2:: ActivateOrCycle("Visual Studio", , "devenv.exe")

; 넘패드 3 → Udemy
Numpad3:: ActivateOrCycle("Udemy ahk_exe chrome.exe", , 'chrome.exe --new-window "https://www.udemy.com/"')

; 넘패드 4 → 치지직
Numpad4:: {
    prevMode := SetTitleMatchMode("RegEx")
    ActivateOrCycle("치지직|CHZZK", , 'chrome.exe --new-window "https://chzzk.naver.com/"')
    SetTitleMatchMode(prevMode)
}

; 넘패드 5 → SOOP (숲티비)
Numpad5:: {
    prevMode := SetTitleMatchMode("RegEx")
    ActivateOrCycle("SOOP|아프리카|Afreeca", , 'chrome.exe --new-window "https://www.sooplive.com/"')
    SetTitleMatchMode(prevMode)
}

; 넘패드 6 → YouTube
Numpad6:: ActivateOrCycle("YouTube ahk_exe chrome.exe", , 'chrome.exe --new-window "https://www.youtube.com/"')

; 넘패드 7 → 네이버
Numpad7:: {
    prevMode := SetTitleMatchMode("RegEx")
    ActivateOrCycle("NAVER|네이버", , 'chrome.exe --new-window "https://www.naver.com/"')
    SetTitleMatchMode(prevMode)
}

; 넘패드 8 → 메모장
Numpad8:: ActivateOrCycle("ahk_exe notepad.exe", , "notepad.exe")

; 넘패드 9 → 크롬 새 창
Numpad9:: Run "chrome.exe --new-window"

; 넘패드 + (클로드)
NumpadAdd:: {
    prevMode := SetTitleMatchMode("RegEx")
    ; "Claude"라는 단어가 포함된 크롬 창을 찾거나 없으면 새 창으로 엽니다.
    ActivateOrCycle("Claude ahk_exe chrome.exe", , 'chrome.exe --new-window "https://claude.ai/"')
    SetTitleMatchMode(prevMode)
}

; 넘패드 - (제미나이)
NumpadSub:: {
    prevMode := SetTitleMatchMode("RegEx")
    ; "Gemini"라는 단어가 포함된 크롬 창을 찾거나 없으면 새 창으로 엽니다.
    ActivateOrCycle("Gemini ahk_exe chrome.exe", , 'chrome.exe --new-window "https://gemini.google.com/"')
    SetTitleMatchMode(prevMode)
}

; 넘패드 / → 이전 탭으로 이동 (Ctrl + Shift + Tab)
NumpadDiv:: Send "^+{Tab}"

; 넘패드 * → 다음 탭으로 이동 (Ctrl + Tab)
NumpadMult:: Send "^{Tab}"