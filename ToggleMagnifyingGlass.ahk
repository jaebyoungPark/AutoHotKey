#Requires AutoHotkey v2.0

toggle := false

$#RButton::
{
    global toggle
    toggle := !toggle
    
    if (toggle) {
        ; 방법 1: NumpadAdd 사용 (넘패드 +)
        Send "{LWin down}{NumpadAdd}{LWin up}"
        
    } else {
        ; Win + Esc
        Send "{LWin down}{Esc}{LWin up}"
    }
}