#Requires AutoHotkey v2.0
#SingleInstance Force

; 100ms마다 ShowTitle 함수를 반복 실행
SetTimer ShowTitle, 2000

ShowTitle() {
    if !WinExist("A") {
        return
    }

    try {
        title := WinGetTitle("A")
        ToolTip(title)
        
        ; 🎯 [추가] 툴팁을 띄우고 1초(1000ms) 뒤에 자동으로 지우는 타이머 작동
        SetTimer(() => ToolTip(), -1000) 
        
    } catch {
        ToolTip()
    }
}