#Requires AutoHotkey v2.0

$!Space:: {
    Send "!{Space}"            ; 진짜 Alt+Space 조합으로 전송 (Space 단독 아님)
    KeyWait "Space"
    KeyWait "Alt"
    Send "{Alt Up}"            ; Alt 눌림 상태 정리
}