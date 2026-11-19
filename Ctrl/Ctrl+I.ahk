$^i::
{
    start := A_TickCount
    KeyWait "i"
    elapsed := (A_TickCount - start) / 1000.0

    ; 0.2 ~ 0.55초 + Visual Studio일 때만 if 블록 생성
    if (elapsed >= 0.2 && elapsed <= 0.55 && WinActive("ahk_exe devenv.exe"))
    {
        SendText "if ()`n{`n}`n"
        Send "{Up 3}"
        Send "{Right 4}"
    }
    else
    {
        ; 기존 Ctrl+I 동작
        Send "{Blind}^i"
    }
}