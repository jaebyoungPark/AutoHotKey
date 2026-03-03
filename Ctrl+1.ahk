#Requires AutoHotkey v2

$^1::
{
; Visual Studio에서만 동작
if !WinActive("ahk_exe devenv.exe")
return

StartTime := A_TickCount
KeyWait "1"
Elapsed := (A_TickCount - StartTime) / 1000.0

if (Elapsed < 0.3)
{
    SendText 'UE_LOG(LogTemp, Warning, TEXT("Begin"));'
    Send "{Left 38}"
}
else if (Elapsed >= 0.3 && Elapsed < 1)
{
    SendText 'UE_LOG(LogTemp, Warning, TEXT(" : %s"), *.ToString());'
    Send "{Left 23}"
}

}