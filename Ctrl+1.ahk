#Requires AutoHotkey v2

$^1::
{
    ; Visual Studio에서만 동작
    if !WinActive("ahk_exe devenv.exe")
        return

    StartTime := A_TickCount
    KeyWait "1"
    Elapsed := (A_TickCount - StartTime) / 1000.0

    if (Elapsed < 0.2)
    {
        SendText 'AB_LOG(LogTemp, Warning, TEXT(""));'
        Send "{Left 33}"
    }
    else if (Elapsed >= 0.2 && Elapsed < 0.55)
    {
        SendText 'AB_LOG(LogTemp, Warning, TEXT("[] : %s"), *.ToString());'
        Send "{Left 24}"
    }
    else if (Elapsed >= 0.55 && Elapsed < 1)
    {
        SendText 'Debug::Print(TEXT(""));'
        Send "{Left 4}"
    }
}