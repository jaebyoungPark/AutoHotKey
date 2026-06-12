#Requires AutoHotkey v2.0

^+Space::
{
    TargetURL := "https://chatgpt.com/g/g-FvT4UOsoA-caes"
    TargetTitle := "CAES"

    hwnd := WinExist(TargetTitle " ahk_exe chrome.exe")
        || WinExist("ChatGPT ahk_exe chrome.exe")

    if (hwnd)
    {
        if (hwnd = WinExist("A"))
        {
            WinMinimize(hwnd)
        }
        else
        {
            if (WinGetMinMax(hwnd) = -1)
                WinRestore(hwnd)

            WinActivate(hwnd)
        }
    }
    else
    {
        ; 마우스 위치 얻기
        MouseGetPos &mx, &my

        ; 마우스가 위치한 모니터 찾기
        monitorCount := MonitorGetCount()

        Loop monitorCount
        {
            MonitorGet(A_Index, &left, &top, &right, &bottom)

            if (mx >= left && mx < right && my >= top && my < bottom)
            {
                targetMonitor := A_Index
                break
            }
        }

        ; Chrome 새 창 실행
        Run('chrome.exe --new-window "' TargetURL '"')

        ; Chrome 창이 뜰 때까지 대기
        if WinWait("ahk_exe chrome.exe", , 5)
        {
            hwnd := WinExist("ahk_exe chrome.exe")

            ; 해당 모니터 작업영역 가져오기
            MonitorGetWorkArea(targetMonitor, &l, &t, &r, &b)

            width := 1400
            height := 1000

            x := l + ((r - l) - width) // 2
            y := t + ((b - t) - height) // 2

            WinMove(x, y, width, height, hwnd)
            WinActivate(hwnd)
        }
    }
}