#Requires AutoHotkey v2.0

; 각 사이트는 새 창으로 열고 해당 탭이 활성 상태여야 검색 가능
; 다른 탭이 활성화되어 있으면 WinExist가 못 찾을 수 있음

; 넘패드 1 → Visual Studio
Numpad1::
{
    if WinExist("Visual Studio")
    {
        WinActivate
    }
    else
    {
        Run "devenv.exe"
    }
}

; 넘패드 2 → Udemy
Numpad2::
{
    if WinExist("Udemy")
    {
        WinActivate
    }
    else
    {
        Run "https://www.udemy.com/"
    }
}

; 넘패드 3 → 치지직
Numpad3::
{
    if WinExist("치지직") || WinExist("CHZZK")
    {
        WinActivate
    }
    else
    {
        Run "https://chzzk.naver.com/"
    }
}

; 넘패드 4 → YouTube
Numpad4::
{
    if WinExist("YouTube ahk_exe chrome.exe")
    {
        WinActivate
    }
    else
    {
        Run "https://www.youtube.com/"
    }
}

; 넘패드 5 → 네이버
Numpad5::
{
    if WinExist("NAVER") || WinExist("네이버")
    {
        WinActivate
    }
    else
    {
        Run "https://www.naver.com/"
    }
}

; 넘패드 6 → 메모장
Numpad6::
{
    if WinExist("ahk_exe notepad.exe")
    {
        WinActivate
    }
    else
    {
        Run "notepad.exe"
    }
}
; 넘패드 9 → 크롬 새 창
Numpad9::
{
    Run "chrome.exe"
}