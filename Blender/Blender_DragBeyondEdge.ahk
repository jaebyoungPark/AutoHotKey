
;펜 커서가 안넘어가서 걍 보류중

#Requires AutoHotkey v2.0
#SingleInstance Force

;DllCall("User32\SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
;CoordMode "Mouse", "Screen"
;
;SetTimer(CheckScreenEdge, 5)
;
;CheckScreenEdge()
;{
;    if !WinActive("ahk_exe blender.exe")
;        return
;
;    if !IsBlenderDrawModeForEdge()
;        return
;
;    ; D 키를 물리적으로 누르고 있을 때
;    if !GetKeyState("d", "P")
;        return
;
;    static lastWarp := 0
;
;    if (A_TickCount - lastWarp < 100)
;        return
;
;    MouseGetPos &x, &y
;
;    hwnd := WinExist("A")
;
;    hMonitor := DllCall(
;        "User32\MonitorFromWindow",
;        "ptr", hwnd,
;        "uint", 2,
;        "ptr"
;    )
;
;    mi := Buffer(40, 0)
;    NumPut("UInt", 40, mi)
;
;    if !DllCall("User32\GetMonitorInfoW", "ptr", hMonitor, "ptr", mi)
;        return
;
;    left   := NumGet(mi, 4, "Int")
;    top    := NumGet(mi, 8, "Int")
;    right  := NumGet(mi, 12, "Int")
;    bottom := NumGet(mi, 16, "Int")
;
;    newX := x
;    newY := y
;
;    ; 왼쪽 → 오른쪽
;    if (x <= left + 5)
;        newX := right - 15
;
;    ; 오른쪽 → 왼쪽
;    else if (x >= right - 6)
;        newX := left + 15
;
;    ; 위쪽 → 아래쪽
;    else if (y <= top + 5)
;        newY := bottom - 15
;
;    ; 아래쪽 → 위쪽
;    else if (y >= bottom - 6)
;        newY := top + 15
;
;    else
;        return
;
;    result := DllCall(
;        "User32\SetCursorPos",
;        "int", newX,
;        "int", newY
;    )
;
;    if result
;        lastWarp := A_TickCount
;}
;
;
;; Blender Sculpt / Texture Paint 모드 확인
;IsBlenderDrawModeForEdge()
;{
;    modeFile := A_Temp "\blender_mode.txt"
;
;    if !FileExist(modeFile)
;        return false
;
;    try
;    {
;        mode := Trim(FileRead(modeFile, "UTF-8"))
;        return (mode = "SCULPT" || mode = "PAINT_TEXTURE")
;    }
;    catch
;    {
;        return false
;    }
;}
