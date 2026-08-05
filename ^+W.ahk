#Requires AutoHotkey v2.0

^+w::{
    if WinActive("ahk_exe blender.exe") {
        ; 블렌더에서는 원래 Ctrl+Shift+W 동작 그대로 전달
        Send("^+w")
    } else {
        ; 다른 프로그램에서는 아무 동작 안 하고 툴팁만 표시
        ToolTip("아무동작 안함")
        SetTimer(() => ToolTip(), -1000) ; 1초 후 툴팁 제거
    }
}