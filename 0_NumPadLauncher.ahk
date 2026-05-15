#Requires AutoHotkey v2.0

ActivateOrCycle(searchTitle, exePath := "", runCommand := "") {
    static WinIndexes := Map()
    
    ; 인덱스 초기화
    if !WinIndexes.Has(searchTitle)
        WinIndexes[searchTitle] := 1

    ; 대상 창 목록 가져오기
    windows := WinGetList(searchTitle)
    count := windows.Length

    ; 1. 창이 하나도 없으면 실행 후 종료
    if (count = 0) {
        if (runCommand != "")
            Run(runCommand)
        return
    }

    ; 2. 저장된 인덱스가 현재 창 개수를 초과하면 1로 리셋 (Error: Invalid index 방지)
    if (WinIndexes[searchTitle] > count) {
        WinIndexes[searchTitle] := 1
    }

    currentIndex := WinIndexes[searchTitle]
    activeHwnd := WinActive("A")

    ; 3. 현재 활성 창이 리스트의 해당 인덱스 창과 같다면 '다음' 창으로 인덱스 이동
    if (activeHwnd = windows[currentIndex]) {
        currentIndex := (currentIndex >= count) ? 1 : currentIndex + 1
    }

    ; 4. 최종 결정된 인덱스로 창 활성화
    try {
        WinActivate(windows[currentIndex])
        WinIndexes[searchTitle] := currentIndex
    } catch {
        WinIndexes[searchTitle] := 1
    }
}

; --- 단축키 할당부 (동일) ---

Numpad1:: ActivateOrCycle("Visual Studio", , "devenv.exe")
Numpad2:: ActivateOrCycle("Udemy ahk_exe chrome.exe", , 'chrome.exe --new-window "https://www.udemy.com/"')
Numpad3:: {
    prevMode := SetTitleMatchMode("RegEx")
    ActivateOrCycle("치지직|CHZZK", , 'chrome.exe --new-window "https://chzzk.naver.com/"')
    SetTitleMatchMode(prevMode)
}
Numpad4:: ActivateOrCycle("YouTube ahk_exe chrome.exe", , 'chrome.exe --new-window "https://www.youtube.com/"')
Numpad5:: {
    prevMode := SetTitleMatchMode("RegEx")
    ActivateOrCycle("NAVER|네이버", , 'chrome.exe --new-window "https://www.naver.com/"')
    SetTitleMatchMode(prevMode)
}
Numpad6:: ActivateOrCycle("ahk_exe notepad.exe", , "notepad.exe")
Numpad7:: ActivateOrCycle("Unreal Editor")
Numpad9:: Run "chrome.exe --new-window"