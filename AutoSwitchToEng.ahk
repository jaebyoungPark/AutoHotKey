#Requires AutoHotkey v2.0

;만약 capslock + 1, capslock + 2 에 이상이 생기면 그냥 이거 지워. 이 코드 때문임

InstallKeybdHook()

global EnglishSwitchDone := false
SetTimer(CheckKeyboardIdle, 250)

CheckKeyboardIdle() {
    global EnglishSwitchDone

    ; CapsLock을 누르고 있는 동안에도 건드리지 않음
    if (A_TimeIdleKeyboard < 5000 || GetKeyState("CapsLock", "P")) {
        EnglishSwitchDone := false
        return
    }
    if (EnglishSwitchDone)
        return

    EnglishSwitchDone := true
    SwitchToEnglish()
}

SwitchToEnglish() {
    DetectHiddenWindows true   ; 이 함수가 도는 스레드에만 적용

    hwnd := DllCall("GetForegroundWindow", "Ptr")
    if (!hwnd)
        return

    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0, "UInt")
    hkl := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    if ((hkl & 0xFFFF) != 0x0412)   ; 한국어 입력기가 아니면 종료
        return

    imeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (!imeWnd)
        return

    ; 응답 없는 창에서 스크립트가 5초씩 멈추지 않게 타임아웃 100ms
    try {
        conv := SendMessage(0x283, 0x1, 0, , "ahk_id " imeWnd, , , , 100)
        if (conv & 0x1)
            SendMessage(0x283, 0x2, conv & ~0x1, , "ahk_id " imeWnd, , , , 100)
    }
}