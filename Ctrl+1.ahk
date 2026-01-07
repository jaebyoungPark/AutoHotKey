#Requires AutoHotkey v2
HotkeyList := ["$^1"]
$^1::
{
    ; Visual Studio 에서만 동작
    if !WinActive("ahk_exe devenv.exe")
        return
    
    SendText 'UE_LOG(LogTemp, Warning, TEXT(":%s"), *.ToString());'
    Send "{Left 21}"  ; 커서를 : 앞으로 이동
}