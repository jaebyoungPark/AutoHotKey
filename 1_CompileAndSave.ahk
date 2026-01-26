#Requires AutoHotkey v2.0

^!NumpadEnter::  ; Ctrl + Alt + 넘패드 Enter
{
    ; 현재 활성 창 체크
    isUE := WinActive("ahk_exe UE4Editor.exe")
          || WinActive("ahk_exe UnrealEditor.exe")
          || InStr(WinGetTitle("A"), "Unreal Editor")

    if isUE
    {
        ToolTip("컴파일 후 저장")
        SetTimer(() => ToolTip(), -700)  ; 0.7초 후 ToolTip 제거

        SendInput("{F7}")  ; F7 전송
        Sleep(200)
        Send("^s")          ; Ctrl+S 전송
    }
    else
    {
        ; 다른 환경이라면 기존 동작 그대로
        Send("^!{Enter}")  ; Ctrl+Alt+Enter를 그냥 전송
    }

    return
}