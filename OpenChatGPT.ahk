#Requires AutoHotkey v2.0

^+Space::
{
    TargetURL := "https://chatgpt.com/g/g-FvT4UOsoA-caes"
    TargetTitle := "CAES" ; 창 제목에서 찾을 핵심 키워드

    ; 1. 해당 페이지가 열려 있는 Chrome 창이 있는지 확인
    hwnd := WinExist(TargetTitle " ahk_exe chrome.exe") || WinExist("ChatGPT ahk_exe chrome.exe")

    if (hwnd)
    {
        ; 2. 이미 해당 창이 현재 활성화(최상단)된 창인지 확인
        if (hwnd = WinExist("A"))
        {
            ; 이미 최상단이라면 -> 최소화
            WinMinimize(hwnd)
        }
        else
        {
            ; 켜져 있지만 뒤에 있거나 최소화 상태라면 -> 복구 및 활성화
            if (WinGetMinMax(hwnd) = -1) 
            {
                WinRestore(hwnd)
            }
            WinActivate(hwnd)
        }
    }
    else
    {
        ; 3. 창이 아예 발견되지 않는다면 -> 💡 인자를 추가하여 완전히 새로운 '새 창'으로 열기
        Run('chrome.exe --new-window "' TargetURL '"')
    }
}