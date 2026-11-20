#Requires AutoHotkey v2.0

;파일명 : Blender_CursorToMiddle.ahk 

; 모니터별 DPI 배율을 반영하도록 설정
DllCall("User32\SetThreadDpiAwarenessContext", "ptr", -4, "ptr")

CoordMode "Mouse", "Screen"

#HotIf WinActive("ahk_exe blender.exe")

+s::
{
    hwnd := WinExist("A")

    ; Blender 창이 위치한 모니터 확인
    hMonitor := DllCall(
        "User32\MonitorFromWindow",
        "ptr", hwnd,
        "uint", 2,
        "ptr"
    )

    ; 모니터의 실제 화면 영역 가져오기
    mi := Buffer(40, 0)
    NumPut("UInt", 40, mi)

    if !DllCall("User32\GetMonitorInfoW", "ptr", hMonitor, "ptr", mi)
        return

    left   := NumGet(mi, 4, "Int")
    top    := NumGet(mi, 8, "Int")
    right  := NumGet(mi, 12, "Int")
    bottom := NumGet(mi, 16, "Int")

    ; 모니터 중앙으로 이동
    centerX := Floor((left + right) / 2)
    centerY := Floor((top + bottom) / 2)

    MouseMove centerX, centerY, 0
}

#HotIf