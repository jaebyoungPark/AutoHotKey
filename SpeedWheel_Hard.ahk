#Requires AutoHotkey v2.0

global InstantWheelStep := 10  ; 한 번에 10번 휠 이동

+WheelUp::InstantWheel("Up")
+WheelDown::InstantWheel("Down")

InstantWheel(dir) {
    global InstantWheelStep
    ; Sleep 없이 루프 돌리면 거의 동시에 10번 보내짐
    Loop InstantWheelStep {
        Send "{Wheel" dir "}"
    }
}