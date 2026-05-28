#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; 전역 변수
; ==============================
global magnifierOn1 := false
global isComboTriggered := false
global isVirtualDown := false ; vk15 대신 '잠금 상태'를 기억할 전역 플래그

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
    KeyWait "p"
    elapsed := A_TickCount - start

    ; [1] GOM64 (최우선 처리)
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "c"
            return
        }
    }

    ; [2] YouTube (최우선 처리)
    title := WinGetTitle("A")
    if InStr(title, "YouTube") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }
    
    ; [3] Udemy (단독 로직 유지, 가상 잠금 대상에서 완전 제외)
    if InStr(title, "Udemy") {
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
        return
    }

    ; [4] Visual Studio 특정 기능 (550ms 미만 헤더 전환 유지)
    if WinActive("ahk_exe devenv.exe") {
        if (elapsed >= 200 && elapsed < 550) {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
            return
        }
    }

    ; [5] Unreal Engine 특정 기능 (450ms 미만 에셋 서랍 유지)
    if IsUnrealActive() {
        if (elapsed >= 200 && elapsed < 450) {
            CoordMode "Mouse", "Screen"
            ToolTip "Content Drawer"
            SetTimer(() => ToolTip(), -700)
            Send "^ "
            return
        }
    }

    ; Udemy를 제외한 모든 환경에서 200ms 미만인 경우 가상 잠금 작동
    if (elapsed < 200) {
        ToggleVirtualLock()
        return
    }
}

; 윈도우에 키를 보내지 않고, 오직 스크립트 내부 상태만 토글하는 함수
ToggleVirtualLock() {
    global isVirtualDown, isComboTriggered
    
    isVirtualDown := !isVirtualDown 
    
    if (isVirtualDown) {
        isComboTriggered := false
        ShowDebug("가상 잠금 ON (숫자 사용 가능)")
    } else {
        ShowDebug("가상 잠금 OFF (플랫폼 스위칭)")
    }
}


; ==============================================================================
; 2. 한/영 키(vk15) 자체를 물리적으로 제어하는 구역
; ==============================================================================

; 한/영 키를 누르면 윈도우 메커니즘에 의해 일단 한/영이 즉시 바뀝니다.
~vk15:: {
    global isComboTriggered := false
    ShowDebug("vk15 물리 누름")
}

; 키를 뗄 때의 구역입니다.
~vk15 up:: {
    global isComboTriggered, isVirtualDown
    
    if (!isVirtualDown) {
        if (!isComboTriggered) {
            ; 숫자를 한 번도 안 누르고 그냥 뗐다면, 누를 때 정상적으로 바뀐 상태가 그대로 유지됩니다.
            ShowDebug("vk15 단독 입력: 한/영 전환 완료")
        } else {
            ; ★ 중요: 이미 숫자를 누르는 순간(HandleKey) 한/영을 제자리로 돌려놓았기 때문에,
            ; 뗄 때는 추가적인 Send("{vk15}") 없이 조용히 디버깅 문구만 띄우고 종료합니다.
            ShowDebug("조합 입력 완료: 한/영 복구 완료 상태")
        }
    }
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


; --- 보조 함수들 ---
; ★ 요청하신 즉시 복구 로직이 적용된 구간입니다.
HandleKey(num) {
    global isComboTriggered, isVirtualDown
    
    ; [★ 핵심 수정] 
    ; ^!+p 가상 잠금 상태가 아닐 때(즉, 진짜 손가락으로 한/영 키를 누르고 있는 상태에서)
    ; 처음으로 숫자가 눌린 타이밍이라면 바뀐 한/영 키를 즉시 원래대로 돌려놓습니다.
    if (!isVirtualDown && !isComboTriggered) {
        Send("{vk15}") 
        ShowDebug("숫자 입력 감지: 한/영 즉시 원상복구!")
    }
    
    isComboTriggered := true ; 조합이 실행되었음을 마킹
    SendInput(num)
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