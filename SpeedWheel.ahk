#Requires AutoHotkey v2.0

HotkeyList := ["+WheelUp", "+WheelDown"]

+WheelUp:: {
    Send "{WheelUp 3}"
}

+WheelDown:: {
    Send "{WheelDown 3}"
}