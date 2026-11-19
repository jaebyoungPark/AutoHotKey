#Requires AutoHotkey v2

; -----------------------------------------------------------------
; 활성 창이 Visual Studio('devenv.exe')이면서, 동시에 블렌더가 아닐 때만 작동
; -----------------------------------------------------------------
#HotIf WinActive("ahk_exe devenv.exe") and !WinActive("ahk_exe blender.exe")

$^1::
{
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

#HotIf ; HotIf 조건 초기화