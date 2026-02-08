#Requires AutoHotkey v2.0

^!NumpadEnter::  ; Ctrl + Alt + 넘패드 Enter
{
    ; 현재 활성 창이 Unreal Engine인지 체크
    isUE :=
           WinActive("ahk_exe UE4Editor.exe")
        || WinActive("ahk_exe UnrealEditor.exe")
        || InStr(WinGetTitle("A"), "Unreal Editor")
        || WinActive("ahk_class UnrealWindow")

    if isUE
    {
        ToolTip("컴파일 후 저장")
        SetTimer(() => ToolTip(), -600)  ; 0.6초 후 ToolTip 제거

        SendInput("{F7}")   ; Compile
        Sleep(250)
        Send("^s")          ; Save
    }
    else
    {
        ; 다른 환경이라면 기존 동작 그대로
        Send("^!{Enter}")
    }
}