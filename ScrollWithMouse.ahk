#Requires AutoHotkey v2.0
#SingleInstance Force

global FastScrollCount := 10
global SlowScrollCount := 2

+WheelUp::InstantWheel("Up", FastScrollCount)
+WheelDown::InstantWheel("Down", FastScrollCount)

!WheelUp::InstantWheel("Up", SlowScrollCount)
!WheelDown::InstantWheel("Down", SlowScrollCount)

InstantWheel(direction, repeatCount) {
    Loop repeatCount {
        Send "{Wheel" direction "}"
    }
}