#Requires AutoHotkey v2.0

; 토글 상태 변수 (true로 시작하여 첫 실행시 U가 되도록)
global toggleState := true

; Ctrl + Alt + 마우스 휠 업 (모든 창에서 감지)

HotkeyList := ["^!WheelUp"]

^!WheelUp::
{
    global toggleState

    ; Visual Studio가 활성화되어 있는지 확인
    if !WinActive("ahk_exe devenv.exe") {
        return
    }

    if (toggleState) {
        ; ==========================
        ; 주석 해제 (U)
        ; ==========================
        ToolTip "주석 Toggle : UNCOMMENT (U)"
        SetTimer(() => ToolTip(), -800)

        Loop 2 {
            Send "{Ctrl down}"
            Sleep 50
            Send "{k down}"
            Sleep 50
            Send "{k up}"
            Sleep 50
            Send "{u down}"
            Sleep 50
            Send "{u up}"
            Sleep 50
            Send "{Ctrl up}"
            Sleep 100
        }
    } else {
        ; ==========================
        ; 주석 처리 (C)
        ; ==========================
        ToolTip "주석 Toggle : COMMENT (C)"
        SetTimer(() => ToolTip(), -800)

        Send "{Ctrl down}"
        Sleep 50
        Send "{k down}"
        Sleep 50
        Send "{k up}"
        Sleep 50
        Send "{c down}"
        Sleep 50
        Send "{c up}"
        Sleep 50
        Send "{Ctrl up}"
    }

    ; 토글 상태 전환
    toggleState := !toggleState
}