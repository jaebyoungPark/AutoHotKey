; 메인 스크립트
#Include CloseTap.ahk
#Include GoToDeclaration.ahk
#Include GoToDefinition.ahk
#Include ToggleSuspend.ahk
#Include OpenBookmark.ahk
#Include InputNumPad.ahk
#Include WinTap.ahk
#Include SwitchCPP.ahk
#include MediaSpeed.ahk


MySuspended := false

; 배열에서 토글 키 제거, toggle 키는 절대 넣지마
HotkeyList := ["$XButton1", "$^!+o", "$XButton1", "$^!+p", "$^+a", "$XButton2", "^F1", "^F2", "^F3", "^F3", "^F4", "^F5", "^F6", "^F7", "^F8", "$^+="] 