#Requires AutoHotkey v2.0

ToggleTaskbarAutoHide()

; 마우스를 작업표시줄에서 치우고 포커스를 해제해야 숨김이 적용됨
MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2, 0)
if WinExist("ahk_class Progman")
    WinActivate
Sleep 200
ExitApp

ToggleTaskbarAutoHide() {
    static ABM_GETSTATE := 0x4
    static ABM_SETSTATE := 0xA
    static ABS_AUTOHIDE := 0x1
    static ABS_ALWAYSONTOP := 0x2

    size := (A_PtrSize = 8) ? 48 : 36
    abd := Buffer(size, 0)
    NumPut("UInt", size, abd, 0)                                       ; cbSize
    NumPut("Ptr", WinExist("ahk_class Shell_TrayWnd"), abd, A_PtrSize) ; hWnd

    state := DllCall("shell32\SHAppBarMessage", "UInt", ABM_GETSTATE, "Ptr", abd, "UInt")

    newState := (state & ABS_AUTOHIDE) ? ABS_ALWAYSONTOP : ABS_AUTOHIDE
    NumPut("Ptr", newState, abd, size - A_PtrSize)                     ; lParam

    DllCall("shell32\SHAppBarMessage", "UInt", ABM_SETSTATE, "Ptr", abd)
}