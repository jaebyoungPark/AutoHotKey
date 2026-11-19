#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2
SetTitleMatchMode("RegEx")
;파일명 : 0_NumAndNumpadLauncher_Blender_v2.ahk 이며, 0_Func_Modules.ahk 에 있는 함수를 쓰는 중

#Include "0_Func_Modules.ahk"

; ==================================================
; 메인 파일 전용 함수
; ==================================================
VSCodeSmartLauncher() {
    if ProcessExist("Code.exe") || ProcessExist("code.exe") {
        if hwnd := WinExist("ahk_exe Code.exe") {
            if (WinGetMinMax("ahk_id " hwnd) = -1)
                WinRestore("ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
            return
        }
    }
    Run("cmd.exe /c start /b code", , "Hide")
}

; ==================================================
; 단축키 매핑 (프로그램 및 웹사이트)
; ==================================================

; --- 블렌더 단축키 ---
Numpad1:: {
    if KeyWait("Numpad1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", false)
    } else {
        Run("blender.exe")
        KeyWait("Numpad1")
    }
}

1:: {
    if KeyWait("1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", false)
    } else {
        Run("blender.exe")
        KeyWait("1")
    }
}

; --- VS Code 스마트 런처 ---
Numpad2:: VSCodeSmartLauncher()
2::        VSCodeSmartLauncher()

;======[3, Numpad3] 인프런 사이트=========
;Numpad3:: OpenSite("Numpad3", "Inflearn|인프런", "https://www.inflearn.com/")
;3::        OpenSite("3", "Inflearn|인프런", "https://www.inflearn.com/")
;======[3, Numpad3] 콜로소 사이트=========
;Numpad3:: OpenSite("Numpad3", "Coloso|콜로소", "https://coloso.co.kr/classroom/236440")
;3::        OpenSite("3", "Coloso|콜로소", "https://coloso.co.kr/classroom/236440")
;======[3, Numpad3] 유데미 사이트=========
Numpad3:: OpenSite("Numpad3", "Udemy|유데미", "https://www.udemy.com/")
3::        OpenSite("3", "Udemy|유데미", "https://www.udemy.com/")
;==========================================

Numpad4:: OpenSite("Numpad4", "치지직|CHZZK", "https://chzzk.naver.com/")
4::        OpenSite("4", "치지직|CHZZK", "https://chzzk.naver.com/")
Numpad5:: OpenSite("Numpad5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
5::        OpenSite("5", "SOOP|아프리카|Afreeca", "https://www.sooplive.com/")
Numpad6:: OpenSite("Numpad6", "YouTube", "https://www.youtube.com/")
6::        OpenSite("6", "YouTube", "https://www.youtube.com/")

; --- Numpad7: 왼쪽 방향키 ---
Numpad7:: {
    Send("{Left}")
    ToolTip("◀")
    SetTimer(() => ToolTip(), -200)
}
7:: {
    Send("{Left}")
    ToolTip("◀")
    SetTimer(() => ToolTip(), -200)
}

; --- Numpad8: ChatGPT (Edge) ---
8::
Numpad8:: {
    global capsComboUsed := true
    OpenEdgeApp("ChatGPT (Edge)", "https://chatgpt.com/")
}

; --- Numpad9: 오른쪽 방향키 ---
Numpad9:: {
    Send("{Right}")
    ToolTip("▶")
    SetTimer(() => ToolTip(), -200)
}
9:: {
    Send("{Right}")
    ToolTip("▶")
    SetTimer(() => ToolTip(), -200)
}

NumLock:: OpenSite("9", "Epic Games Documentation|Epic Developer Community", "https://dev.epicgames.com/documentation/")

$NumpadAdd::
{
    if KeyWait("NumpadAdd", "T0.2") {
        ; 단독 입력 시 동작
    } else {
        KeyWait("NumpadAdd")
    }
}
#HotIf GetKeyState("NumpadAdd", "P")
Numpad0::Send "{Numpad0}"
Numpad1::Send "{Numpad1}"
Numpad2::Send "{Numpad2}"
Numpad3::Send "{Numpad3}"
Numpad4::Send "{Numpad4}"
Numpad5::Send "{Numpad5}"
Numpad6::Send "{Numpad6}"
Numpad7::Send "{Numpad7}"
Numpad8::Send "{Numpad8}"
Numpad9::Send "{Numpad9}"
#HotIf

; --- F3 단축키 ---
$F3:: {
    if WinActive("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass") {
        Send("{F3}")
    } else {
        OpenSite("F3", "Claude", "https://claude.ai/")
    }
}
NumpadSub:: OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")
F4::         OpenSite("F4", "Gemini", "https://gemini.google.com/")

; 최소화 / 전체화면
Numpad0:: {
    if KeyWait("Numpad0", "T0.27")
        WinMinimize("A")
    else
        Send("{F11}"), KeyWait("Numpad0")
}

; --- NumpadDiv ---
$NumpadDiv:: HandleCtrlShiftA() ; OpenBookmark.ahk 에 있음

; --- NumpadMult 복합 기능 ---
NumpadMult:: {
    if WinActive("ahk_exe ChatGPT.exe")
        return Send("{Down 2}")
    if WinActive("ahk_exe Photos.exe")
        return Send("{Right}")
    if WinActive("ahk_class UnrealWindow")
        return MoveMouseToOtherMonitor()
    Send "^{Tab}"
}

; ==================================================
; [CapsLock + 알파벳/숫자 단축키]
; 누르는 즉시 대소문자 토글, 조합 키를 쓰면 누르기 전 상태로 복구
; (capsComboUsed, capsHeld, capsPrev, actionToken 은 WindowLib.ahk 에 선언됨)
; ==================================================
*CapsLock:: {
    global capsComboUsed, capsHeld, capsPrev
    if capsHeld          ; 키 반복 입력 무시
        return
    capsHeld := true
    capsComboUsed := false
    capsPrev := GetKeyState("CapsLock", "T")
    SetCapsLockState(!capsPrev)     ; 누르는 즉시 토글

    SetTimer(CheckAndTurnOffCapsLock, 0)
}

*CapsLock up:: {
    global capsHeld
    capsHeld := false
    SetTimer(CheckAndTurnOffCapsLock, 250)
}

#HotIf GetKeyState("CapsLock", "P")

1::
Numpad1:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_exe i)blender.exe ahk_class GHOST_WindowClass", "blender.exe", false)
}

2::
Numpad2:: {
    CapsCombo()
    if WinExist("ahk_exe UnrealEditor.exe")
        WinActivate("ahk_exe UnrealEditor.exe")
}

3::
Numpad3:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_class GomPlayerPlus64_3.x ahk_exe GOM64.EXE", "GOM64.EXE", false)
}

4::
Numpad4:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_class Notepad", "notepad.exe", false)
}

5::
Numpad5:: {
    CapsCombo()
    OpenSite("5", "치지직|CHZZK", "https://chzzk.naver.com/")
}

6::
Numpad6:: {
    CapsCombo()
    OpenSite("6", "YouTube", "https://www.youtube.com/")
}

7::
Numpad7:: {
    CapsCombo()
    OpenSite("7", "GOOGLE|구글", "https://www.google.com/")
}

8::
Numpad8:: {
    CapsCombo()
    OpenSite("8", "Photos", "ms-photos:")
}

9::
Numpad9:: {
    CapsCombo()
    CenterMouseAndExecuteMacro()
}

0::
Numpad0:: {
    CapsCombo()
    WinMinimize("A")
}

F1:: {
    CapsCombo()

    BlenderPath := "E:\Programs\blender.exe"
    BlendFile := "G:\All\All_Blender\RigPractice.blend"

    ToolTip("🦴 RigPractice.blend")
    SetTimer(() => ToolTip(), -1000)

    if !FileExist(BlendFile) {
        ToolTip("⚠️ Blender 파일을 찾을 수 없음")
        SetTimer(() => ToolTip(), -2000)
        return
    }

    for hwnd in WinGetList("ahk_exe blender.exe") {
        try {
            Title := WinGetTitle("ahk_id " hwnd)

            if InStr(Title, "RigPractice.blend") {
                if (WinGetMinMax("ahk_id " hwnd) = -1)
                    WinRestore("ahk_id " hwnd)

                WinActivate("ahk_id " hwnd)
                return
            }
        }
    }

    Run('"' BlenderPath '" "' BlendFile '"')
}

SC029:: {
    CapsCombo()
    OpenEdgeApp("ChatGPT (Edge)", "https://chatgpt.com/")
}

#HotIf