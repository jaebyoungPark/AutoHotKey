; Ctrl + 위쪽 방향키 = 마우스 휠 위로
^Up:: {
    While GetKeyState("Up", "P") && GetKeyState("Ctrl", "P") {
        Send "{WheelUp}"
        Sleep 50
    }
}

; Ctrl + 아래쪽 방향키 = 마우스 휠 아래로
^Down:: {
    While GetKeyState("Down", "P") && GetKeyState("Ctrl", "P") {
        Send "{WheelDown}"
        Sleep 50
    }
}