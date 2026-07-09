#Requires AutoHotkey v2.0
#SingleInstance Force

; 언리얼이나 비주얼스튜디오의 컴파일이나 저장은 절대 Main 의MouseOverExe 같은 커서인식으로 active 여부를 판별하지
; 말고, 너가 직접 마우스 클릭해서 활성화 시키고 winactive 로 실행해. 안그러면 저장 안될 가능성이 있어서 진짜 위험하다. 

; ⚠️ [중요] main.ahk에 선언된 외부 전역 변수 및 배열을 안전하게 참조하기 위해 상단 선언
global unrealExes


; ==============================================================================
; 1. Ctrl+Alt+Shift+P 단축키 구역 (Udemy 제외 전역 토글 연동)
; ==============================================================================
; ==============================================================================
; 1. Ctrl+Alt+Shift+P 단축키 구역 (Udemy 제외 전역 토글 연동)
; ==============================================================================
^!+p::
{
    global unrealExes ; ◀ main.ahk에 있는 전역 변수를 이 블록 안으로 가져옴
    start := A_TickCount
    
    ; ⚡ 반응성 개선: 200ms 동안만 P 키가 떼어지기를 기다립니다 (블로킹 방지)
    isReleased := KeyWait("p", "T0.2")
    elapsed := A_TickCount - start

    ; 🔍 마우스 커서 아래에 있는 창의 ID(Hwnd)와 타이틀을 정확히 가져옴
    MouseGetPos ,, &mouseHwnd
    try {
        title := WinGetTitle("ahk_id " mouseHwnd)
    } catch {
        title := ""
    }

    ; [최우선] 200ms 미만으로 짧게 뗐을 때 -> 가상 잠금 즉시 토글
    ; (Udemy, YouTube와 함께 블렌더 환경도 가상 잠금 토글에서 제외되도록 처리)
    if (
        elapsed < 200
        && isReleased
        && !InStr(title, "Udemy")
        && !InStr(title, "YouTube")
        && !InStr(title, "블렌더")
    ) {
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

    ; [2] 블렌더 학습 페이지 추가 (Chrome 등에서 '블렌더' 타이틀 감지 시)
    if InStr(title, "블렌더") {
        EnsureWindowActive(mouseHwnd)
        ToolTip "▶ Speed Up (Blender)"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }

    ; [3] YouTube (마우스 위치 창 활성화 로직 반영)
    if InStr(title, "YouTube") {
        EnsureWindowActive(mouseHwnd)
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+."
        return
    }
    
    ; [4] Udemy (마우스 위치 창 활성화 로직 반영)
    if InStr(title, "Udemy") {
        EnsureWindowActive(mouseHwnd)
        ToolTip "▶ Speed Up"
        SetTimer(() => ToolTip(), -700)
        SendInput "+{Right}"
        return
    }

    ; [5] Visual Studio 특정 기능
    if WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe Code.exe") {
        if (elapsed >= 200 && elapsed < 550) {
            ToolTip "Header"
            SetTimer(() => ToolTip(), -600)
            Send "^!{F12}"
            return
        }
    }
    

    ; [6] Unreal Engine 특정 기능 (Content Drawer 열기)
    isUnrealMouseOver := false
    for exe in unrealExes {
        if MouseOverExe(exe) {
            isUnrealMouseOver := true
            break
        }
    }

    if (isUnrealMouseOver) {
        if (elapsed >= 200 && elapsed < 450) {
            ; 마우스 아래의 창을 확실하게 인식하고 활성화
            WinActivate("ahk_id " mouseHwnd)      

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

; --- [구역 B] 넘패드 키 구역 ---
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

$NumpadDiv::SendInput "{Blind}{NumpadDiv}"      ; /
$NumpadMult::SendInput "{Blind}{NumpadMult}"    ; *
$NumpadSub::SendInput "{Blind}{NumpadSub}"      ; -
$NumpadAdd::SendInput "{Blind}{NumpadAdd}"      ; +
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
; 4. Ctrl+Alt+Shift+O 구역
; ==============================
; ==============================
; 4. Ctrl+Alt+Shift+O 구역
; ==============================
^!+o::
{
    global unrealExes ; ◀ main.ahk에 있는 전역 변수를 이 블록 안으로 가져옴
    global magnifierOn1
    start := A_TickCount
    KeyWait "o"
    elapsed := A_TickCount - start

    ; 마우스 커서 아래 창의 HWND 미리 획득
    MouseGetPos ,, &mouseHwnd

    ; [1] GOM64
    if WinActive("ahk_exe GOM64.EXE") {
        if (elapsed < 250) {
            Send "x"
            return
        }
    }
    
    ; [2] Notepad (메모장)
    if (WinActive("ahk_exe notepad.exe") || WinActive("ahk_exe Notepad.exe") || WinActive("ahk_class Notepad")) {
        if (elapsed < 200) {
            Send "^s"
            ToolTip "💾 저장 완료"
            SetTimer(() => ToolTip(), -500)
        }
        else if (elapsed < 600) {
            Send "^!s"
            ToolTip "📁 전체 저장"
            SetTimer(() => ToolTip(), -500)
        }
        return
    }

    ; [3] Chrome
    if WinActive("ahk_exe chrome.exe") {
        ; 돋보기 토글 기능 (시간 조건이 맞을 때 최우선 처리)
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

        try {
            mouseTitle := WinGetTitle("ahk_id " mouseHwnd)
        } catch {
            mouseTitle := ""
        }

        ; 🌟 [블렌더 분기 추가] 마우스 아래 창 타이틀에 '블렌더'가 포함된 경우
        if InStr(mouseTitle, "블렌더") {
            EnsureWindowActive(mouseHwnd)
            ToolTip "◀ Speed Down (Blender)"
            SetTimer(() => ToolTip(), -700)
            SendInput "+,"  ; Shift + , 수행
            return
        }
        else if InStr(mouseTitle, "YouTube") {
            EnsureWindowActive(mouseHwnd)
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+,"
            return
        }
        else if InStr(mouseTitle, "Udemy") {
            EnsureWindowActive(mouseHwnd)
            ToolTip "◀ Speed Down"
            SetTimer(() => ToolTip(), -700)
            SendInput "+{Left}"
            return
        }
    }

    ; [4] ChatGPT
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

    ; [5] Unreal Engine 컴파일 및 저장 기능 (v2 기반 괄호 오류 수정본)
    isUnrealMouseOver := false
    for exe in unrealExes {
        if MouseOverExe(exe) {
            isUnrealMouseOver := true
            break
        }
    }

    if (isUnrealMouseOver) {
        if (elapsed < 200) {
            ; 상단에서 이미 구한 mouseHwnd를 활용해 확실하게 활성화
            WinActivate("ahk_id " mouseHwnd)

            if !WinWaitActive("ahk_id " mouseHwnd, , 1) {
                ToolTip "❌ 활성화 실패"
                SetTimer(() => ToolTip(), -1000)
                return
            }

            ToolTip "컴파일 후 저장. v2"
            SetTimer(() => ToolTip(), -700)

            Click "Left"
            Sleep 100
            Send "{F7}"
            Sleep 40
            
            ; 요청 사항: 엔터 제거 상태 유지, 슬립 후 전체 저장
            Sleep 250
            Send "^+s"
            return 
        }
    }

    ; [6] Visual Studio 저장 및 기능
    if WinActive("ahk_exe devenv.exe") || WinActive("ahk_exe Code.exe") {
        if (elapsed < 200) {
            Send "^+s"
            ToolTip "전체 저장 완료 😄"
            SetTimer(() => ToolTip(), -1000)
        }
        else if (elapsed < 600) {
            ToolTip "Def"
            SetTimer(() => ToolTip(), -600)
            Send "{F12}"
        }
        return
    }
}
; ==============================================================================
; 5. Udemy 전용 단축키 (선호 버전 2 적용)
; ==============================================================================
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