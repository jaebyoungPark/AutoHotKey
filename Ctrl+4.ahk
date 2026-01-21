#Requires AutoHotkey v2.0

; *Editor 의 Zoom -1 일 때만 가능*

^4::  ; Ctrl + 4
{
    ; Unreal Editor에서만 동작
    if !WinActive("ahk_exe UnrealEditor.exe")
        return

    ; ------------------------------
    ; 1. "print s" 입력 후 Enter
    ; ------------------------------
    SendText "print s"
    Sleep 50
    Send "{Enter}"
    Sleep 200

    ; ------------------------------
    ; 3. Enter 이후 시점의 마우스 위치
    ; ------------------------------
    MouseGetPos &x, &y

    ; 4. 살짝 아래로 이동
    MouseMove(x + 7.5, y + 62, 0)
    Sleep 400

    ; 이동 후 기준 좌표 다시 확보
    MouseGetPos &x2, &y2

    ; ------------------------------
    ; 5~7. 자연스러운 클릭 → 좌로 드래그 → 놓기
    ; ------------------------------
    Click "Down"
    Sleep 50
    MouseMove(-150, 100, 10, "R")
    Sleep 70
    Click "Up"
    Sleep 500

    ; ------------------------------
    ; 8. "ap" 입력 후 Enter
    ; ------------------------------
    SendText "ap"
    Sleep 50
    Send "{Enter}"
    Sleep 200

    ; ------------------------------
    ; 현재 커서 위치 다시 획득
    ; ------------------------------
    MouseGetPos &x3, &y3

    ; 살짝 우측 하단으로 이동
    MouseMove(x3 + 44, y3 + 33, 5)
    Sleep 200

    ; 클릭
    Click
    Sleep 80

    ; ------------------------------
    ; 9. 공백 → ':' → 공백
    ; ------------------------------
    Send "{Space}"
    Sleep 20
    SendText ":"
    Sleep 20
    Send "{Space}"

    ; ------------------------------
    ; 10. 왼쪽 방향키 ← 3번
    ; ------------------------------
    Send "{Left 3}"
    Sleep 100


}