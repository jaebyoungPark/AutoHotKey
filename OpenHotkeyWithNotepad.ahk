#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe explorer.exe")

; Alt(!) + 마우스 좌클릭(LButton)
!LButton:: {
    ; 마우스 클릭 위치의 파일이 정상적으로 먼저 선택되도록 실행
    Click()
    Sleep(50)
    
    filePath := GetSelectedFile()
    if (filePath != "") {
        if (!InStr(FileGetAttrib(filePath), "D")) {
            ; 파일 이름만 추출해서 툴팁에 보여주기 위함
            SplitPath(filePath, &fileName)
            
            ; 마우스 커서 위치에 "메모장으로 여는 중..." 툴팁 표시
            ToolTip("메모장으로 여는 중`n▶ " fileName)
            
            ; 사용자가 Alt 키를 물리적으로 뗄 때까지 대기
            KeyWait("Alt")
            
            ; 메모장 실행 및 PID 획득
            Run('notepad.exe "' filePath '"',,, &notepadPID)
            
            if (WinWait("ahk_pid " notepadPID,, 1.5)) {
                winTitle := "ahk_pid " notepadPID
                WinActivate(winTitle)
                
                ; 만약의 경우를 대비한 최상단 쐐기 포커스
                WinSetAlwaysOnTop(1, winTitle)
                Sleep(50)
                WinSetAlwaysOnTop(0, winTitle)
                WinActivate(winTitle)
                
                ; 열기 완료 후 툴팁 변경 및 0.8초 뒤 자동으로 꺼지게 설정
                ToolTip("열기 완료!")
                SetTimer(() => ToolTip(), -800)
            } else {
                ; 실행 실패 시 툴팁 즉시 끄기
                ToolTip()
            }
        }
    }
}

GetSelectedFile() {
    activeHwnd := WinActive("A")
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.hwnd == activeHwnd) {
                for item in window.Document.SelectedItems {
                    return item.Path
                }
            }
        }
    }
    return ""
}
#HotIf