#Requires AutoHotkey v2.0

; *Editor 의 Zoom -1 일 때만 가능*

HotkeyList := ["^3"]

^3::
{
    ; 언리얼 엔진 에디터가 활성화되어 있을 때만 실행
    if !WinActive("ahk_exe UnrealEditor.exe")
        return

    ; 1. print t 입력
    SendInput("print text")
    Sleep(30)

    ; 2. Enter
    SendInput("{Enter}")
    Sleep(200)

    ; 3. Enter 이후 시점의 마우스 위치
    MouseGetPos &x, &y		

    ; 4. 살짝 아래로 이동
    MouseMove(x + 6, y + 58, 0)
    Sleep(400)

    ; 🔹 이동 후 기준 좌표 다시 확보
    MouseGetPos &x2, &y2

    ; 5~7. 자연스러운 클릭 → 좌로 드래그 → 놓기
    Click "Down"
    Sleep(50)
    MouseMove(-150, 100, 10, "R")
    Sleep(70)
    Click "Up"
    Sleep(500)

    ; 8. format t 입력
    SendInput("format t")
    Sleep(400)

    ; 9. Enter
    SendInput("{Enter}")
    Sleep(500)

    ; =========================
    ; 🔟 Enter 이후 추가 동작
    ; =========================

    ; 현재 커서 위치 다시 획득
    MouseGetPos &x3, &y3

    ; 살짝 우측 하단으로 이동
    MouseMove(x3 + 72, y3 + 33, 5)
    Sleep(200)

    ; 클릭
    Click
    Sleep(80)

    ; {1}{2} 입력
    SendInput(": {{}0{}},   : {{}1{}}")
    Sleep(120)

    ; Enter
    SendInput("{Enter}")
}