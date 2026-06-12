#Requires AutoHotkey v2.0
$!d::
{
    focusedHwnd := ControlGetFocus("A")
    hwnd := focusedHwnd ? focusedHwnd : WinGetID("A")

    hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if (hIME)
    {
        ; 일반 IME 환경
        if IsKoreanMode(hwnd)
        {
            SetIMEToEnglish(hwnd)
            Sleep(50)
        }
    }
    else
    {
        ; TSF 환경 (VS 등) → VK15 폴백
        if GetKeyState("VK15", "T")
        {
            Send("{VK15}")
            Sleep(50)
        }
    }
    Send("{AltDown}d{AltUp}")
}

IsKoreanMode(winHwnd) {
    if !(hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", winHwnd, "Ptr"))
        return false
    res := DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 1, "Ptr", 0, "Ptr")
    return (res & 1)
}
SetIMEToEnglish(winHwnd) {
    if (hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", winHwnd, "Ptr")) {
        DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 2, "Ptr", 0, "Ptr")
        DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 6, "Ptr", 1, "Ptr")
    }
}