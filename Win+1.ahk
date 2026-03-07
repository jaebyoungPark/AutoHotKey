#Requires AutoHotkey v2.0

#1::
{
    ; Check if Visual Studio is the active window
    activeWin := WinGetTitle("A")
    activeExe := WinGetProcessName("A")
    
    ; Visual Studio process names
    if (activeExe = "devenv.exe")
    {
        ; Send the if statement text
        SendText('if (GetWorld() && GetWorld()->IsGameWorld()) { }')
    }
    else
    {
        ; Default Win+1 behavior - switch to first taskbar item
        Send("#1")
    }
}