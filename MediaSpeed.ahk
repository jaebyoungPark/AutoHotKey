#Requires AutoHotkey v2.0


; ==============================
; 전역 변수
; ==============================
magnifierOn1 := false

; ==============================
; Unreal Engine 활성 판별 함수
; ==============================
IsUnrealActive() {
    return (
           WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || InStr(WinGetTitle("A"), "Unreal Editor")
        || WinActive("ahk_class UnrealWindow")
    )
}

; ==============================
; Ctrl+Alt+Shift+P
; ==============================
^!+p::
{
    start := A_TickCount
    KeyWait "p"
    elapsed := A_TickCount - start

    ; GOM64
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "c"
            return
        }
    }

    ; YouTube / Udemy
    title := WinGetTitle("A")
    if InStr(title, "YouTube") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }
    else if InStr(title, "Udemy") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
        return
    }

    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            ToolTip "→"
            SetTimer(() => ToolTip(), -600)
            Send "{Right}"
        }
        else if (elapsed < 550) {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
        }
        return
    }

    ; Unreal Engine
    CoordMode "Mouse", "Screen"
    if IsUnrealActive() {
        if (elapsed < 200) {
            ToolTip "Escape"
            SetTimer(() => ToolTip(), -700)
            SendInput "+{F1}"
            Sleep 50
            MouseMove 546, 78, 0
        }
        else if (elapsed < 450) {
            ToolTip "Content Drawer"
            SetTimer(() => ToolTip(), -700)
            Send "^ "
        }
        return
    }
}

; ==============================
; Ctrl+Alt+Shift+O
; ==============================
^!+o::
{
    global magnifierOn1
    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; GOM64
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "x"
            return
        }
    }

    ; Chrome
    if WinActive("ahk_exe chrome.exe") {
        if (elapsed >= 200 && elapsed < 600) {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1) {
                SendInput "{LWin down}{NumpadAdd}{LWin up}"
                ToolTip "🔍 돋보기 켜짐"
            } else {
                SendInput "{LWin down}{Esc}{LWin up}"
                Sleep 100
                SendInput "{f}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }

        title := WinGetTitle("A")
        if InStr(title, "YouTube") {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+,"
            return
        }
        else if InStr(title, "Udemy") {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+{Left}"
            return
        }
    }

    ; ChatGPT
    if WinActive("ahk_exe ChatGPT.exe") {
        if (elapsed >= 200 && elapsed < 600) {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1)
                SendInput "{LWin down}{NumpadAdd}{LWin up}"
            else
                SendInput "{LWin down}{Esc}{LWin up}"
            return
        }
    }

    ; Unreal Engine
    if IsUnrealActive() {
        if (elapsed < 250) {
            ToolTip "컴파일 후 저장"
            SetTimer(() => ToolTip(), -700)
            SendInput "{F7}"
            Sleep 300
            Send "^s"
        }
        return
    }

    ; Visual Studio
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed < 250) {
            Send "^+s"
            ToolTip "전체 저장 완료 😄"
            SetTimer(() => ToolTip(), -1000)
        }
        else if (elapsed < 550) {
            ToolTip "Def"
            SetTimer(() => ToolTip(), -600)
            Send "{F12}"
        }
    }
}