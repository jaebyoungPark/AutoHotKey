#Requires AutoHotkey v2.0
#SingleInstance Force
#HotIf WinActive("ahk_exe explorer.exe")

; Ctrl + Shift + Z
^+z:: {
    Click()
    Sleep(50)

    filePath := GetSelectedFile()
    if (filePath = "")
        return
    if InStr(FileGetAttrib(filePath), "D")
        return

    SplitPath(filePath, &fileName)

    notepadPath := FindNotepadPP()
    if (notepadPath = "") {
        ToolTip("Notepad++ 경로를 찾을 수 없습니다.")
        SetTimer(() => ToolTip(), -2000)
        return
    }

    ToolTip("Notepad++로 여는 중`n▶ " fileName)
    KeyWait("Alt")

    try {
        Run('"' notepadPath '" "' filePath '"')
        SetTimer(() => ToolTip(), -800)
    } catch as err {
        ToolTip("Notepad++ 실행 실패!`n" err.Message)
        SetTimer(() => ToolTip(), -2000)
    }
}

#HotIf

FindNotepadPP() {
    candidates := [
        A_ProgramFiles "\Notepad++\notepad++.exe",
        EnvGet("ProgramFiles(x86)") "\Notepad++\notepad++.exe",
        EnvGet("LOCALAPPDATA") "\Programs\Notepad++\notepad++.exe"
    ]
    for p in candidates {
        if FileExist(p)
            return p
    }

    ; 레지스트리 App Paths 확인
    for root in ["HKLM", "HKCU"] {
        try {
            p := RegRead(root "\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe")
            if FileExist(p)
                return p
        }
    }
    return ""
}

GetSelectedFile() {
    activeHwnd := WinActive("A")
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.hwnd == activeHwnd) {
                for item in window.Document.SelectedItems
                    return item.Path
            }
        }
    }
    return ""
}