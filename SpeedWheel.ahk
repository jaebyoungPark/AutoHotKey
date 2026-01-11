#Requires AutoHotkey v2.0

HotkeyList := ["!WheelUp", "!WheelDown"]



; Alt + 휠 업 → 5단 스무스 WheelUp
!WheelUp:: {
    Loop 6 {
        Click "WheelUp"
        Sleep 30
    }
}

; Alt + 휠 다운 → 5단 스무스 WheelDown
!WheelDown:: {
    Loop 6 {
        Click "WheelDown"
        Sleep 30

    }
}

