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

#Requires AutoHotkey v2.0
#SingleInstance Force

; --- 전역 변수 설정 ---
global isComboTriggered := false
global isVirtualDown := false ; ★ vk15 대신 '잠금 상태'를 기억할 전역 플래그

; ==============================================================================
; 1. Ctrl+Alt+Shift+P 단축키 구역 (Visual Studio & Unreal Engine 토글 연동)
; ==============================================================================
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
        if (elapsed < 200) {
            ToggleVirtualLock() ; ★ 가상 잠금 함수 호출
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
            ToggleVirtualLock() ; ★ 가상 잠금 함수 호출
        }
        else if (elapsed < 450) {
            ToolTip "Content Drawer"
            SetTimer(() => ToolTip(), -700)
            Send "^ "
        }
        return
    }
}

; ★ 윈도우에 키를 보내지 않고, 오직 스크립트 내부 상태만 토글하는 함수
ToggleVirtualLock() {
    global isVirtualDown, isComboTriggered
    
    isVirtualDown := !isVirtualDown ; 상태 반전 (true <-> false)
    
    if (isVirtualDown) {
        isComboTriggered := false
        ShowDebug("가상 잠금 ON (숫자 대기 중...)")
    } else {
        ShowDebug("가상 잠금 OFF (해제)")
    }
}


; ==============================================================================
; 2. 한/영 키(vk15) 자체를 물리적으로 제어하는 구역 (올려주신 깔끔한 방식 유지)
; ==============================================================================
vk15:: {
    global isComboTriggered := false
    ShowDebug("vk15 물리 누름")
}

vk15 up:: {
    global isComboTriggered, isVirtualDown
    
    ; 가상 잠금 상태가 아닐 때만 단독 입력 처리
    if (!isVirtualDown) {
        if (!isComboTriggered) {
            Send("{vk15}") 
            ShowDebug("vk15 단독 입력: 한/영 전환")
        } else {
            ShowDebug("조합 입력 완료: 한/영 전환 차단됨")
        }
    }
}


; ==============================================================================
; 3. 조합 키 작동 구역
; ==============================================================================
; 진짜 한/영 키를 누르고 있거나(P), ^!+p로 가상 잠금이 켜진 상태(isVirtualDown) 둘 다 작동!
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


; --- 보조 함수들 ---
HandleKey(num) {
    global isComboTriggered := true
    SendInput(num)
    ShowDebug("조합 키 " num " 입력 성공!")
}

ShowDebug(message) {
    ToolTip("[디버깅] " message)
    SetTimer(() => ToolTip(), -1000)
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
	 ; Notepad (메모장)
    if (
       WinActive("ahk_exe notepad.exe")
    || WinActive("ahk_exe Notepad.exe")
    || WinActive("ahk_class Notepad")
    )
    {
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
	    Send "{Enter}"     ; 먼저 Enter
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


; ==============================
; Shift + , / .  (Udemy 전용)
; 이거 동작 이상해서 보류하고 그 아래에 있는걸로 사용함
; ==============================
; ~+,::
; {
;     if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy")
;     {
;         ToolTip "◀ Speed Down"
;         SetTimer(() => ToolTip(), -700)
;         SendInput "+{Left}"
;     }
; }

; ~+.:: 
; {
;     if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy")
;     {
;         ToolTip "▶ Speed Up"
;         SetTimer(() => ToolTip(), -700)
;         SendInput "+{Right}"
;     }
; }


$+,::
{
    if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy")
    {
        ToolTip "◀ Speed Down"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Left}"
    }
    else
    {
        SendInput "+,"   ; 🔥 원래 동작 직접 실행
    }
}

$+.::
{
    if WinActive("ahk_exe chrome.exe") && InStr(WinGetTitle("A"), "Udemy")
    {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
    }
    else
    {
        SendInput "+."   ; 🔥 원래 동작 직접 실행
    }
}