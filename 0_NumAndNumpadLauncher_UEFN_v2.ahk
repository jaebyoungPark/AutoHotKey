#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2
SetTitleMatchMode("RegEx")

; 파일명 : 0_NumAndNumpadLauncher_UEFN_v2.ahk
; 함수/전역 상태(actionToken 등)는 0_Func_Modules.ahk 에서 가져옴 (같은 폴더에 두기)
#Include "%A_ScriptDir%\0_Func_Modules.ahk"

; 이 스크립트 전용 설정: CapsLock 자동 꺼짐 대기 2.5초
; (0_Func_Modules.ahk 에 capsIdleMs 가 없으면 아래 참고 항목 확인)
capsIdleMs := 2500

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
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", true)
    } else {
        Run("blender.exe")
        KeyWait("Numpad1")
    }
}

1:: {
    if KeyWait("1", "T0.27") {
        ActivateOrCycleEx("ahk_exe i)blender\.exe ahk_class GHOST_WindowClass", "blender.exe", true)
    } else {
        Run("blender.exe")
        KeyWait("1")
    }
}

; --- VS Code 스마트 런처 ---
Numpad2:: VSCodeSmartLauncher()
2::        VSCodeSmartLauncher()

Numpad3:: OpenSite("Numpad3", "Udemy|유데미", "https://www.udemy.com/")
3::        OpenSite("3", "Udemy|유데미", "https://www.udemy.com/")

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

; ==================================================
; NumpadAdd (+) 키 (유튜브 환경에서 Shift + .)
; ==================================================
$NumpadAdd::
{
    if WinActive("YouTube") {
        Send("{Shift Down}{.}{Shift Up}")
        ToolTip("⏩ Faster (Shift + .)")
        SetTimer(() => ToolTip(), -200)
        return
    }

    if KeyWait("NumpadAdd", "T0.2") {
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

; ==================================================
; NumpadSub (-) 키 (유튜브 환경에서 Shift + ,)
; ==================================================
NumpadSub:: {
    if WinActive("YouTube") {
        Send("{Shift Down}{,}{Shift Up}")
        ToolTip("⏪ Slower (Shift + ,)")
        SetTimer(() => ToolTip(), -200)
        return
    }

    OpenSite("NumpadSub", "Gemini", "https://gemini.google.com/")
}
F4::         OpenSite("F4", "Gemini", "https://gemini.google.com/")

; 스페이스바 / 전체화면
Numpad0:: {
    if KeyWait("Numpad0", "T0.27")
        Send("{Space}")
    else
        Send("{F11}"), KeyWait("Numpad0")
}

$NumpadDiv:: HandleCtrlShiftA() ; OpenBookmark.ahk 에 있음

NumpadMult:: {
    if KeyWait("NumpadMult", "T0.22") {
        if WinActive("ahk_exe ChatGPT.exe")
            return Send("{Down 2}")
        if WinActive("ahk_exe Photos.exe")
            return Send("{Right}")
        if WinActive("ahk_class UnrealWindow")
            return MoveMouseToOtherMonitor()

        Send("{Space}")
        ToolTip("␣ Space")
        SetTimer(() => ToolTip(), -200)
    } else {
        SendInput("^#/")
        ToolTip("⌨️ ^#/")
        SetTimer(() => ToolTip(), -200)
        KeyWait("NumpadMult")
    }
}

; ==================================================
; [CapsLock + 알파벳/숫자 단축키]
; (capsComboUsed, capsHeld, capsPrev, actionToken 은 0_Func_Modules.ahk 에 선언됨)
; ==================================================
*CapsLock:: {
    global capsComboUsed, capsHeld, capsPrev
    if capsHeld
        return
    capsHeld := true
    capsComboUsed := false
    capsPrev := GetKeyState("CapsLock", "T")
    SetCapsLockState(!capsPrev)

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
    ActivateUnrealClean("ahk_exe (UnrealEditor|UE4Editor|UnrealEditorFortnite-Win64-Shipping)\.exe")
}

2::
Numpad2:: {
    CapsCombo()
    if (ProcessExist("Code.exe") || ProcessExist("code.exe")) {
        if hwnd := WinExist("ahk_exe Code.exe") {
            if (WinGetMinMax("ahk_id " hwnd) = -1)
                WinRestore("ahk_id " hwnd)
            WinActivate("ahk_id " hwnd)
        }
    }
}

3::
Numpad3:: {
    CapsCombo()
    ActivateOrCycleEx("Patreon ahk_exe chrome.exe", 'chrome.exe --new-window "https://www.patreon.com/DruidMechanics/posts/s2-l8-tuples-167235312?collection=2331829"', false)
}

4::
Numpad4:: {
    CapsCombo()
    ActivateOrCycleEx("ahk_exe notepad++.exe", "C:\Program Files\Notepad++\notepad++.exe", false)
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
    if hwnd := WinExist("ahk_exe FortniteClient-Win64-Shipping.exe") {
        if (WinGetMinMax("ahk_id " hwnd) = -1)
            WinRestore("ahk_id " hwnd)
        WinActivate("ahk_id " hwnd)
    }
}

SC029:: {
    CapsCombo()
    OpenEdgeApp("ChatGPT (Edge)", "https://chatgpt.com/")
}

#HotIf