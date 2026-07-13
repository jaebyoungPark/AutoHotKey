$!a::
{
    ; 1. 블렌더인 경우 💡 (툴팁 띄우고 기존 동작 수행)
    if WinActive("ahk_exe blender.exe")
    {
        ToolTip("Blender: Alt+A")              ; 💬 블렌더 작동 안내 문구 출력
        Send("!a")                             ; 🎬 블렌더 고유의 Alt + A 기능 실행
        SetTimer(() => ToolTip(), -1000)       ; ⏱️ 1초 뒤 툴팁 삭제
    }
    ; 2. 파일 탐색기인 경우
    else if WinActive("ahk_class XamlExplorerHostIslandWindow")
    {
        Send("{Alt Down}{Left}")
    }
    ; 3. VS Code인 경우
    else if WinActive("ahk_exe Code.exe")
    {
        ToolTip("Left")
        Send("{Left}")
        SetTimer(() => ToolTip(), -1000)
    }
    ; 4. 구글 크롬인 경우
    else if WinActive("ahk_class Chrome_WidgetWin_1")
    {
        Send("{Down 2}")
    }
    ; 5. 그 외 기타 프로그램
    else
    {
        Send("{Enter}")
    }
}