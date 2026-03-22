^8::
{
    if WinActive("ahk_exe devenv.exe")
    {
        SendText("/**`n *  `n */")
        Send("{Left 2}{Backspace}{Up}{Right}{Right}")
    }
    else
    {
        Send("^8")
    }
}