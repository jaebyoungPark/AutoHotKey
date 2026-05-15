; 메인 스크립트
#Include 0_Includes.ahk

MySuspended    := false
NumPadSuspended := true

NumPadKeyList := [
    "Numpad1", "Numpad2", "Numpad3",
    "Numpad4", "Numpad5", "Numpad6", "Numpad7", "Numpad8",
    "Numpad9", "NumpadSub", "NumpadAdd", "NumpadDiv", "NumpadMult" 
]
; ← 여기에 추가
for key in NumPadKeyList {
    try {
        Hotkey(key, "Off")
    } catch {
        ; 무시
    }
}


;======================================
; Toggle NumPad
;======================================


HotKeyList := [
    ; 마우스
    "RButton", "XButton1", "XButton2", "MButton",
    "LButton", "+!LButton", "+!RButton", "^LButton", "~LButton", "!LButton",

    ; 휠
    "^+WheelUp", "^+WheelDown",
    "!WheelUp",  "!WheelDown",
    "+WheelUp",  "+WheelDown",
    "^!WheelUp", "^!WheelDown",

    ; 숫자
    "$^1", "$^2", "^3", "^4",
    "^+1", "^+2", "^+3", "^+4", "^8",

    ; 기호/특수
    "$^+=", "^!+p", "^!+o", "$^+a",
    "#+-", "#+=:", "#'", "+!'", "+!;",
    "^``", "^+``", "^SC028", "^+SC028",

    ; 방향키
    "Left", "Right", "Up", "Down",
    "!Left",  "!Right",  "!+Right",  "!+Left",
    "^Left",  "^Right",  "^+Right",  "^+Left",
    "#Left",  "#Right",  "#Up",      "#Down",
    "#^Left", "#^Right", "#^Up",     "#^Down",
    "^+Up",   "^+Down",
    "!Up",    "!Down",
    "!a",     "!d",      "!w",       "!s",

    ; PageUp/Down
    "PgUp", "PgDn", "^PgDown",

    ; NumpadEnter
    "#NumpadEnter", "^NumpadEnter", "^!NumpadEnter", "!NumpadEnter",

    ; Win+Numpad
    "#Numpad5", "#Numpad4", "#Numpad1",
    "!Numpad1", "!Numpad2",

    ; 기타 Win키
    "#,", "#.", "#[", "#]", "#End", "#Delete",
    "#1", "#f",

    ; Shift 조합
    "+Delete", "+End", "+,", "+.", "+Enter",

    ; Alt 조합
    "!n", "!m", "!j", "!i", "!k", "!l",
    "!,", "!.",

    ; Ctrl 조합
    "^c", "^t", "^m", "^f", "^i", "^u", "^p", "^o",
    "^+a",

    ; 단독키
    "RShift", "~F2", "F12", "Esc",

    ; RShift 조합
    "RShift & Tab",
    "RShift & 1", "RShift & 2", "RShift & 3", "RShift & 4", "RShift & 5",
    "RShift & 6", "RShift & 7", "RShift & 8", "RShift & 9", "RShift & 0",

    ; VK15 (한/영) 조합
    "VK15 & w", "VK15 & a", "VK15 & s", "VK15 & d",

    ; vk19 (한자) 조합
    "vk19 + Q", "vk19 + W", "vk19 + E",
    "vk19 + A", "vk19 + S", "vk19 + D",
    "vk19 + Z", "vk19 + X", "vk19 + C",

    ; LWin 조합
    "LWin & Up", "LWin & Left", "LWin & Down", "LWin & Right",
]

; "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음

;======================================
; Shift+F1 + Esc 0.5초 유지 → 종료
;======================================
~+F1::
{
    start := A_TickCount

    while GetKeyState("Esc", "P")
    {
        Sleep 10

        if (A_TickCount - start >= 500)
        {
            SoundPlay "C:\Windows\Media\Windows Critical Stop.wav", 1
            ToolTip "🛑 Script Terminated"
            Sleep 500
            ExitApp
        }
    }
}