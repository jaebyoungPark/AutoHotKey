$^v::
{
    if WinActive("ahk_exe devenv.exe")
    {
        Send "^v"
        Sleep 50
        Send "^k"
        Sleep 50
        Send "^d"

        ToolTip("정렬 완료")
        SetTimer(() => ToolTip(), -1000) ; 1초 후 제거
    }
    else
    {
        Send "^v"
    }
}