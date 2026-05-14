; 메인 스크립트

#Include 0_Includes.ahk



MySuspended := false




HotKeyList := [
    "RButton", "XButton1", "XButton2", "MButton", 
    "LButton", "+!LButton", "+!RButton", "^LButton", "~LButton",
    "^+WheelUp", "^+WheelDown", "!WheelUp", "!WheelDown", 
    "+WheelUp", "+WheelDown", "^!WheelUp", "^!WheelDown",
    "$^1", "$^2", "^3", "^4", "^+1", "^+2", "^+3", "^+4", "^8",
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
    "#1", "!n", "!m", "^``", "^+``", "^SC028", "^+SC028",
    "RShift & Tab", "!j", "!i", "!k", "!l", "^+Up", "^+Down", "+,", "+.", "!,", "!.", "+Enter", "Esc",
    "!LButton", "^+a","#f", "F12", "VK15 & w", "VK15 & a", "VK15 & s", "VK15 & d",
    "vk19 + Q", "vk19 + W", "vk19 + E",
    "vk19 + A", "vk19 + S", "vk19 + D",
    "vk19 + Z", "vk19 + X", "vk19 + C",
    "LWin & Up", "LWin & Left", "LWin & Down", "LWin & Right",
    
    ; 여기에 RShift + 숫자 → Numpad 매핑 추가
    "RShift & 1", "RShift & 2", "RShift & 3", "RShift & 4", "RShift & 5", 
    "RShift & 6", "RShift & 7", "RShift & 8", "RShift & 9", "RShift & 0",

"!a", "!d", "!w", "!s"
]

NumPadSuspended := false
NumPadKeyList := [
    "Numpad1", "Numpad2", "Numpad3",
    "Numpad4", "Numpad5", "Numpad6",
    "Numpad9"
]

;======================================
; Toggle NumPad
;======================================
#Include 0_ToggleNumPad.ahk


; "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음


~+F1::
{
    start := A_TickCount
    
    while GetKeyState("Esc", "P")
    {
        Sleep 10
        
        if (A_TickCount - start >= 500)
        {
            ; 🔊 종료 사운드
            SoundPlay "C:\Windows\Media\Windows Critical Stop.wav", 1
            
            ToolTip "🛑 Script Terminated"
            Sleep 500  ; 소리 들릴 시간
            
            ExitApp
        }
    }
}
