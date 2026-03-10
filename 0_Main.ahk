; 메인 스크립트

#Include 0_Includes.ahk



MySuspended := false



HotKeyList := [
    "RButton", "XButton1", "XButton2", "MButton", 
    "LButton", "RButton", "+!LButton", "+!RButton", "^LButton", "~LButton",
    "^+WheelUp", "^+WheelDown", "!WheelUp", "!WheelDown", 
    "+WheelUp", "+WheelDown", "^!WheelUp", "^!WheelDown",
    "$^1", "$^2", "^3", "^4", "^+1", "^+2", "^+3", "^+4",
    "$^+=", "^!+p", "^!+o", "$^+a",
    "#+-", "#+=:", "#'", "+!'", "+!;", 
    "Left", "Right", "Up", "Down", 
    "!Left", "!Right", "!+Right", "!+Left", 
    "^Left", "^Right", "^+Right", "^+Left", 
    "#Left", "#Right", "#Up", "#Down", 
    "#^Left", "#^Right", "#^Up", "#^Down",
    "PgUp", "PgDn", "^PgDown", 
    "#NumpadEnter", "^NumpadEnter", "^!NumpadEnter", "!NumpadEnter",
    "#Numpad5", "#Numpad4", "#Numpad1",
    "#,", "#.", "#[", "#]", "#End", "#Delete", "+Delete", "+End",
    "!Up", "!Down", "!Numpad1", "!Numpad2",
    "RShift", "~F2", "^c", "^t", "^m", "^f", "^i", "^u", "^p", "^o",
    "#1", "!j", "!k", "^``", "^+``", "^SC028", "^+SC028",
    "RShift & z", "RShift & x", "RShift & c", "RShift & v", "RShift & Tab"
]
; "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음