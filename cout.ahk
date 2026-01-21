#Requires AutoHotkey v2.0

; Shift + Alt + 1
+!1::
{
    ; Visual Studio가 활성 창일 때만 실행
    if WinActive("ahk_exe devenv.exe")
    {
        SendInput "std::cout << << std::endl;{Left 14}"
    }
}