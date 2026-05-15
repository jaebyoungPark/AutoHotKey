#Requires AutoHotkey v2.0

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

    ; 3. 핵심 로직: 창이 하나뿐이거나, 현재 창이 이미 활성화된 상태라면?
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

; --- 아래 단축키 설정은 동일하게 사용하시면 됩니다 ---

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