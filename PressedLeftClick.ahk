#Requires AutoHotkey v2.0
#SingleInstance Force

global LButtonHeld := false

ShowStartTip() {
    ToolTip "PressedLeftClick.ahk"
    SetTimer () => ToolTip(), -600   ; 0.6초 후 자동 제거
}

^RButton::
{
    global LButtonHeld

    ; 크롬 아니면 무시
    if !WinActive("ahk_exe chrome.exe")
        return

    ; 이미 눌려있으면 중복 방지
    if LButtonHeld
        return

    ; 왼쪽 클릭 누르기
    Send "{LButton down}"
    LButtonHeld := true

    ; 시작 표시
    ShowStartTip()
}

^Esc::
{
    global LButtonHeld

    if !LButtonHeld
        return

    ; 왼쪽 클릭 해제
    Send "{LButton up}"
    LButtonHeld := false
}