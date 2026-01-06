; 메인 스크립트
#Include ToggleSuspend.ahk

#Include CloseTap.ahk
#Include OpenBookmark.ahk
#Include InputNumPad.ahk
#Include WinTap.ahk
#Include SwitchCPP.ahk
#Include ^!+p.ahk
#Include ToggleSubstitute.ahk
#Include ControlSound.ahk
#Include SwitchTap&ToggleLens.ahk
#Include SwitchCursor.ahk
#Include SwitchWindow.ahk
#Include SpeedWheel.ahk
#Include GoRight.ahk

;Test
;#Include Test.ahk



MySuspended := false

; 배열에서 토글 키 제거, toggle 키는 절대 넣지마
HotkeyList := ["^!+o", "^!+p", "$XButton1", "$^!+p", "$^+a", "$XButton2", "^F1", "^F2", "^F3", "^F4", "^F5", "^F6", "^F7", "^F8", "$^+=", "$MButton", "!WheelUp", "!WheelDown", "!LButton", "!RButton", "$^RButton", "$RButton", "+WheelUp", "+WheelDown", "^+F10"]

