#Requires AutoHotkey v2.0

; 블렌더에서는 . 입력
#HotIf WinActive("ahk_exe blender.exe")

^+F10::Send("{NumpadDot}")

#HotIf

; 그 외의 프로그램에서는 Win + Tab
^+F10:: {
    ; Win 누르고
    Send("{LWin down}")
    Sleep 50

    ; Tab 누르기
    Send("{Tab}")
    Sleep 50

    ; Win 떼기
    Send("{LWin up}")
}