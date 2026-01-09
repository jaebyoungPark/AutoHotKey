#Requires AutoHotkey v2.0

HotkeyList := ["^!+p", "^!+o"]

; ==============================
; 전역 변수
; ==============================
magnifierOn1 := false

; ==============================
; Ctrl+Alt+Shift+P 핫키
; ==============================
^!+p::
{
    start := A_TickCount
    KeyWait "p"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; 유튜브 환경
    ; ------------------------------
    if InStr(WinGetTitle("A"), "YouTube")
    {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput("+.")  ; 재생속도 올리기
        return
    }

    ; ------------------------------
    ; Udemy 환경
    ; ------------------------------
    else if InStr(WinGetTitle("A"), "Udemy")
    {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput("+{Right}")  ; 재생속도 올리기
        return
    }

    ; ------------------------------
    ; 비주얼 스튜디오 환경
    ; ------------------------------
    if WinActive("ahk_exe devenv.exe")
    {
        if (elapsed < 250)
        {
            ToolTip "→"
            SetTimer(() => ToolTip(), -600)
            Send "{Right}"
        }
        else if (elapsed >= 250 && elapsed < 550)
        {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
        }
        return
    }

    ; ------------------------------
    ; 언리얼 엔진 환경
    ; ------------------------------
    if WinActive("ahk_exe UE4Editor.exe") || WinActive("ahk_exe UnrealEditor.exe")
    {
        ToolTip "Content Drawer"
        SetTimer(() => ToolTip(), -700)
        Send "^ "  ; Ctrl + Space
        return
    }
}

; ==============================
; Ctrl+Alt+O 핫키
; ==============================
^!+o::
{
    global magnifierOn1
    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; ------------------------------
    ; Chrome 환경
    ; ------------------------------
    if WinActive("ahk_exe chrome.exe")
    {
        ; 🔍 돋보기 토글 (200~600ms)
        if (elapsed >= 200 && elapsed < 600)
        {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1)
            {
                SendInput("{LWin down}{NumpadAdd}{LWin up}")
                ToolTip "🔍 돋보기 켜짐"
            }
            else
            {
                SendInput("{LWin down}{Esc}{LWin up}")
                Sleep 100
                SendInput "{f down}{f up}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }

        title := ""
        try title := WinGetTitle("A")

        ; ------------------------------
        ; YouTube
        ; ------------------------------
        if InStr(title, "YouTube")
        {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput("+,")  ; 유튜브 속도 ↓
            return
        }

        ; ------------------------------
        ; Udemy
        ; ------------------------------
        else if InStr(title, "Udemy")
        {
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput("+{Left}")  ; 유데미 속도 ↓
            return
        }
        return
    }

    ; ------------------------------
    ; ChatGPT 환경 (돋보기 토글 추가)
    ; ------------------------------
    if WinActive("ahk_exe ChatGPT.exe")
    {
        ; 🔍 돋보기 토글 (200~600ms)
        if (elapsed >= 200 && elapsed < 600)
        {
            magnifierOn1 := !magnifierOn1
            if (magnifierOn1)
            {
                SendInput("{LWin down}{NumpadAdd}{LWin up}")
                ToolTip "🔍 돋보기 켜짐"
            }
            else
            {
                SendInput("{LWin down}{Esc}{LWin up}")
                Sleep 100
                SendInput "{f down}{f up}"
                ToolTip "🔍 돋보기 꺼짐"
            }
            Sleep 500
            ToolTip
            return
        }
        return
    }

    ; ------------------------------
    ; 언리얼 엔진 환경
    ; ------------------------------
    CoordMode "Mouse", "Screen"  ; 👈 화면 좌표 기준 설정

    title := ""
    try title := WinGetTitle("A")

    if InStr(title, "Unreal Editor")
    {
        if (elapsed < 200)
        {
            ToolTip "컴파일 후 저장"
            SetTimer(() => ToolTip(), -700)
            SendInput("{F7}")
            Sleep 250
            ; Ctrl+S를 다운/업 방식으로 보내기
            Send("{Ctrl down}")  ; Ctrl 누름
            Send("{s down}")     ; S 누름
            Send("{s up}")       ; S 떼기
            Send("{Ctrl up}")    ; Ctrl 떼기
        }
        else if (elapsed >= 200 && elapsed < 450)
        {
            ToolTip "Escape"
            SetTimer(() => ToolTip(), -700)
            SendInput("+{F1}")
            Sleep 50
            MouseMove 546, 78, 0  ; ✔ 정상
        }
        return
    }

    ; ------------------------------
    ; 비주얼 스튜디오 환경
    ; ------------------------------
    if WinActive("ahk_exe devenv.exe")
    {
        if (elapsed < 250)
        {
            ToolTip "<-"
            SetTimer(() => ToolTip(), -600)
            Send "{Left}"
        }
        else if (elapsed >= 250 && elapsed < 550)
        {
            ToolTip "Def"
            SetTimer(() => ToolTip(), -600)
            Send "{F12}"
        }
    }
}