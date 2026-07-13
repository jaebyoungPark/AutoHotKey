#Requires AutoHotkey v2.0
#SingleInstance Force

global FastScrollCount := 10
global SlowScrollCount := 2

; 블렌더 프로세스(blender.exe)가 활성화되어 있지 않을 때만 아래 핫키들을 적용
#HotIf !WinActive("ahk_exe blender.exe")

+WheelUp::InstantWheel("Up", FastScrollCount)
+WheelDown::InstantWheel("Down", FastScrollCount)

!WheelUp::InstantWheel("Up", SlowScrollCount)
!WheelDown::InstantWheel("Down", SlowScrollCount)

#HotIf ; 조건 초기화

InstantWheel(direction, repeatCount) {
    Loop repeatCount {
        Send "{Wheel" direction "}"
    }
}