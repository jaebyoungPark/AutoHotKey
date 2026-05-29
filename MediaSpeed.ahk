#Requires AutoHotkey v2.0
#SingleInstance Force

; ⚠️ [중요] 최상단에 있던 변수 초기화 구문(global 변수 := false)을 모두 삭제했습니다.
; 이제 이 파일은 main.ahk에 선언된 변수를 '가져와서' 사용합니다.

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

; ==============================================================================
; 1. Ctrl+Alt+Shift+P 단축키 구역 (Udemy 제외 전역 토글 연동)
; ==============================================================================
^!+p::
{
    start := A_TickCount
    
    ; ⚡ 반응성 개선: 200ms 동안만 P 키가 떼어지기를 기다립니다 (블로킹 방지)
    isReleased := KeyWait("p", "T0.2")
    elapsed := A_TickCount - start

    title := WinGetTitle("A")

    ; [최우선] 200ms 미만으로 짧게 뗐을 때 -> 가상 잠금 즉시 토글
    if (elapsed < 200 && isReleased && !InStr(title, "Udemy")) {
        ToggleVirtualLock()
        return
    }

    ; [1] GOM64
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "c"
            return
        }
    }

    ; [2] YouTube
    if InStr(title, "YouTube") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }
    
    ; [3] Udemy
    if InStr(title, "Udemy") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
        return
    }

    ; [4] Visual Studio 특정 기능
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed >= 200 && elapsed < 550) {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
            return
        }
    }

    ; [5] Unreal Engine 특정 기능
    if IsUnrealActive() {
        if (elapsed >= 200 && elapsed < 450) {
            CoordMode "Mouse", "Screen"
            ToolTip "Content Drawer"
            SetTimer(() => ToolTip(), -700)
            Send "^ "
            return
        }
    }
}

; 윈도우에 키를 보내지 않고, 오직 스크립트 내부 상태만 토글하는 함수
ToggleVirtualLock() {
    ; main.ahk에 선언된 전역 변수를 함수 내부로 명시적 호출
    global isVirtualDown, isComboTriggered
    
    isVirtualDown := !isVirtualDown 
    
    if (isVirtualDown) {
        isComboTriggered := false
        SoundPlay "C:\Windows\Media\Windows Notify System Generic.wav"
        ShowDebug("가상 잠금 ON (숫자 사용 가능)")
    } else {
        SoundPlay "C:\Windows\Media\Windows Critical Stop.wav"
        ShowDebug("가상 잠금 OFF (플랫폼 스위칭)")
    }
}

; ==============================================================================
; 2. 한/영 키(vk15) 자체를 물리적으로 제어하는 구역
; ==============================================================================
~vk15:: {
    global isComboTriggered := false
}

~vk15 up:: {
    global isComboTriggered, isVirtualDown
}

; ==============================================================================
; 3. 조합 키 작동 구역
; ==============================================================================
#HotIf GetKeyState("vk15", "P") || isVirtualDown
$1:: HandleKey("1")
$2:: HandleKey("2")
$3:: HandleKey("3")
$4:: HandleKey("4")
$5:: HandleKey("5")
$6:: HandleKey("6")
$7:: HandleKey("7")
$8:: HandleKey("8")
$9:: HandleKey("9")
$0:: HandleKey("0")
#HotIf

; --- [구역 B] 넘패드 키 구역 (vk15 및 플래그와 무관, 오직 가상 잠금 때만 작동) ---
#HotIf isVirtualDown
$Numpad1::SendInput "{Blind}{Numpad1}"
$Numpad2::SendInput "{Blind}{Numpad2}"
$Numpad3::SendInput "{Blind}{Numpad3}"
$Numpad4::SendInput "{Blind}{Numpad4}"
$Numpad5::SendInput "{Blind}{Numpad5}"
$Numpad6::SendInput "{Blind}{Numpad6}"
$Numpad7::SendInput "{Blind}{Numpad7}"
$Numpad8::SendInput "{Blind}{Numpad8}"
$Numpad9::SendInput "{Blind}{Numpad9}"
$Numpad0::SendInput "{Blind}{Numpad0}"
#HotIf

HandleKey(num) {
    global isComboTriggered, isVirtualDown
    
    if (!isVirtualDown && !isComboTriggered) {
        Send("{vk15}") 
        ShowDebug("숫자 입력 감지: 한/영 즉시 원상복구!")
    }
    
    isComboTriggered := true
    SendInput(num)
}

ShowDebug(message) {
    ToolTip("[디버깅] " message)
    SetTimer(() => ToolTip(), -1000)
}

; ==============================
; Ctrl+Alt+Shift+O 구역
; ==============================
^!+o::
{
    global magnifierOn1  ; main.ahk의 전역 변수를 가져옴
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
    ; Notepad (메모장)
    if (WinActive("ahk_exe notepad.exe") || WinActive("ahk_exe Notepad.exe") || WinActive("ahk_class Notepad")) {
        if (elapsed < 250) {
            Send "^s"
            ToolTip "💾 저장 완료"
            SetTimer(() => ToolTip(), -800)
        }
        else if (elapsed < 550) {
            Send "^!s"
            ToolTip "📁 전체 저장"
            SetTimer(() => ToolTip(), -800)
        }
        return
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
            Send "{Enter}"
            Sleep 100
            SendInput "{F7}"
            Sleep 300
            Send "^+s"
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

; Udemy 전용 단축키 유지
$+,::
{
    if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy") {
        ToolTip "◀ Speed Down"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Left}"
    } else {
        SendInput "+,"
    }
}

$+.::
{
    if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
    } else {
        SendInput "+."
    }
}