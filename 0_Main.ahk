; 메인 스크립트

#Include 0_Includes.ahk



MySuspended := false



HotKeyList := [
    ; 기존 마우스 버튼
    "RButton", "XButton1", "XButton2", "MButton", 
    "LButton", "RButton", "+!LButton", "+!RButton", "^LButton", "~LButton",

    ; 휠
    "^+WheelUp", "^+WheelDown", "!WheelUp", "!WheelDown", 
    "+WheelUp", "+WheelDown", "^!WheelUp", "^!WheelDown",

    ; 키보드 숫자 / 심볼
    "$^1", "$^2", "^3", "^4", "^+1", "^+2", "^+3", "^+4",
    "$^+=", "^!+p", "^!+o", "$^+a",
    "#+-", "#+=:", "#'", "+!'", "+!;", 

    ; 방향키
    "Left", "Right", "Up", "Down", 
    "!Left", "!Right", "!+Right", "!+Left", 
    "^Left", "^Right", "^+Right", "^+Left", 
    "#Left", "#Right", "#Up", "#Down", 
    "#^Left", "#^Right", "#^Up", "#^Down",

    ; Page / Numpad
    "PgUp", "PgDn", "^PgDown", 
    "#NumpadEnter", "^NumpadEnter", "^!NumpadEnter", "!NumpadEnter",
    "#Numpad5", "#Numpad4", "#Numpad1",

    ; 기타 키
    "#,", "#.", "#[", "#]", "#End", "#Delete", "+Delete", "+End",
    "!Up", "!Down", "!Numpad1", "!Numpad2",
    "RShift", "~F2", "^c", "^t", "^m", "^f", "^i", "^u", "^p", "^o",
    "#1", "!j", "!k","^`", "^+`", "^SC028", "^+SC028"

    ; 🔹 RShift + Z/X/C/V (마우스 이동 핫키)
    "RShift & z", "RShift & x", "RShift & c", "RShift & v"
]
;, "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음
