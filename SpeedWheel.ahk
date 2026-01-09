#Requires AutoHotkey v2.0

HotkeyList := ["!WheelUp", "!WheelDown"]


; Alt + 휠 업 → 4단 스무스 WheelUp
!WheelUp:: {
    Loop 4 {
        Click "WheelUp"
        Sleep 25
    }
}

; Alt + 휠 다운 → 4단 스무스 WheelDown
!WheelDown:: {
    Loop 4 {
        Click "WheelDown"
        Sleep 25
    }
}