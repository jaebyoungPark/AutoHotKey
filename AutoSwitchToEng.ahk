#Requires AutoHotkey v2.0

; 키입력을 안하면 자동으로 한글인지 영어인지 파악한 후, 한글이면 영어로 변환(코드작성 편의용)

InstallKeybdHook()


global EnglishSwitchDone := false
SetTimer(CheckKeyboardIdle, 250)

CheckKeyboardIdle() {
    global EnglishSwitchDone

    if (A_TimeIdleKeyboard < 5000) {
        EnglishSwitchDone := false
        return
    }
    if (EnglishSwitchDone)
        return

    EnglishSwitchDone := true
    SwitchToEnglish()
}

SwitchToEnglish() {
    hwnd := WinExist("A")
    if (!hwnd)
        return

    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0, "UInt")
    hkl := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    if ((hkl & 0xFFFF) != 0x0412)   ; 지금 한국어 레이아웃일 때만
        return

    ; WM_INPUTLANGCHANGEREQUEST = 0x50, en-US HKL = 0x04090409
    PostMessage(0x50, 0, 0x04090409, , "ahk_id " hwnd)
}