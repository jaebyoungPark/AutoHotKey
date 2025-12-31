#Requires AutoHotkey v2.0

#HotIf InStr(WinGetTitle("A"), "YouTube")
^!+p:: SendInput("+.")  ; 재생속도 올리기
^!+o:: SendInput("+,")  ; 재생속도 내리기
#HotIf

#HotIf InStr(WinGetTitle("A"), "Udemy")
^!+p:: SendInput("+{Right}")  ; 재생속도 올리기
^!+o:: SendInput("+{Left}")   ; 재생속도 내리기
#HotIf