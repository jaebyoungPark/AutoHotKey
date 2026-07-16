#Requires AutoHotkey v2.0

; --- 툴팁을 표시하고 자동으로 지우는 헬퍼 함수 ---
ShowNumpadTooltip(num) {
    ToolTip("Numpad " num)
    SetTimer(() => ToolTip(), -500) ; 0.5초(500ms) 후에 툴팁 제거 (음수 값은 1회만 실행됨을 의미)
}

; RShift + 숫자 → Numpad (입력과 동시에 툴팁 표시)
~RShift & 1:: {
    Send("{Numpad1}")
    ShowNumpadTooltip(1)
}
~RShift & 2:: {
    Send("{Numpad2}")
    ShowNumpadTooltip(2)
}
~RShift & 3:: {
    Send("{Numpad3}")
    ShowNumpadTooltip(3)
}
~RShift & 4:: {
    Send("{Numpad4}")
    ShowNumpadTooltip(4)
}
~RShift & 5:: {
    Send("{Numpad5}")
    ShowNumpadTooltip(5)
}
~RShift & 6:: {
    Send("{Numpad6}")
    ShowNumpadTooltip(6)
}
~RShift & 7:: {
    Send("{Numpad7}")
    ShowNumpadTooltip(7)
}
~RShift & 8:: {
    Send("{Numpad8}")
    ShowNumpadTooltip(8)
}
~RShift & 9:: {
    Send("{Numpad9}")
    ShowNumpadTooltip(9)
}
~RShift & 0:: {
    Send("{Numpad0}")
    ShowNumpadTooltip(0)
}