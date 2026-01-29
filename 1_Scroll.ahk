#Requires AutoHotkey v2.0

; 방향키는 안돼. 알트탭 하고 선택할때 알트탭이 풀려버림. 따라서 alt + page나 alt + numpad 로 대체해야함


; ========================================
; Alt + ↑ → (주석 처리됨)
; ========================================
; !Up::
; {
;     if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
;         Send("!{Up}")
;         return
;     }
;     if WinActive("ahk_exe explorer.exe") {
;         Send("!{Up}")
;         return
;     }
;     SendInput("{WheelUp 2}")
; }

; ========================================
; Alt + ↓ → (주석 처리됨)
; ========================================
; !Down::
; {
;     if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
;         Send("!{Down}")
;         return
;     }
;     if WinActive("ahk_exe explorer.exe") {
;         Send("!{Down}")
;         return
;     }
;     SendInput("{WheelDown 2}")
; }

; ========================================
; Alt + Numpad1 → 휠 다운 4번
; ========================================
!Numpad1::
{
    if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
        Send("!{Numpad1}")
        return
    }
    if WinActive("ahk_exe explorer.exe") {
        Send("!{Numpad1}")
        return
    }
    SendInput("{WheelDown 4}")
}

; ========================================
; Alt + Numpad2 → 휠 업 4번
; ========================================
!Numpad2::
{
    if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
        Send("!{Numpad2}")
        return
    }
    if WinActive("ahk_exe explorer.exe") {
        Send("!{Numpad2}")
        return
    }
    SendInput("{WheelUp 4}")
}

; ========================================
; Alt + PgDn → 휠 다운 4번
; ========================================
!PgDn::
{
    if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
        Send("!{PgDn}")
        return
    }
    if WinActive("ahk_exe explorer.exe") {
        Send("!{PgDn}")
        return
    }

    SendInput("{WheelDown 4}")

    ToolTip("▼ Scroll Down")
    SetTimer(() => ToolTip(), -400) ; 0.4초 후 자동 제거
}


; ========================================
; Alt + PgUp → 휠 업 4번
; ========================================
!PgUp::
{
    if WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class TaskSwitcherWnd") {
        Send("!{PgUp}")
        return
    }
    if WinActive("ahk_exe explorer.exe") {
        Send("!{PgUp}")
        return
    }

    SendInput("{WheelUp 4}")

    ToolTip("▲ Scroll Up")
    SetTimer(() => ToolTip(), -400) ; 0.4초 후 자동 제거
}