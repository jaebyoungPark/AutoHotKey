#Requires AutoHotkey v2.0

; ===================================================================
; Shift + 마우스 오른쪽  또는  Ctrl + Shift + 마우스 오른쪽 모두 감지
; ===================================================================
+RButton::
^+RButton::
{
    ; [변경] 물리적으로 Ctrl 키가 눌려 있거나, 단축키 자체에 Ctrl(^)이 포함되어 작동했는지 확인
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        ; Visual Studio인지 확인
        if WinActive("ahk_exe devenv.exe")
        {
            ; 중요: 현재 누르고 있는 마우스 우클릭이 떼어질 때까지 
            ; 단어 선택 단축키가 방해받지 않도록 먼저 물리적 떼어짐을 기다립니다.
            KeyWait("RButton")
            
            ; Blind 모드로 보내서 이미 눌려있는 Ctrl+Shift를 활용해 우측 단어 2번 선택
            Send("{Blind}^{Right}")
            Sleep(10)
            Send("{Blind}^{Right}")
        }
        else
        {
            ; Visual Studio가 아니면 Ctrl+Shift+우클릭 본연의 동작 수행
            Send("^+{RButton}")
        }
    }
    else
    {
        ; Ctrl이 완전히 안 눌렸다면: 마우스를 누르고 있는 동안 드래그(긁기)가 가능하도록 다운/업 처리
        Send("{Blind}{RButton Down}")
        KeyWait("RButton")
        Send("{Blind}{RButton Up}")
    }
}

; ===================================================================
; Shift + 마우스 왼쪽  또는  Ctrl + Shift + 마우스 왼쪽 모두 감지
; ===================================================================
+LButton::
^+LButton::
{
    ; [변경] 물리적으로 Ctrl 키가 눌려 있거나, 단축키 자체에 Ctrl(^)이 포함되어 작동했는지 확인
    if GetKeyState("Ctrl", "P") or InStr(A_ThisHotkey, "^")
    {
        ; Visual Studio인지 확인
        if WinActive("ahk_exe devenv.exe")
        {
            KeyWait("LButton")
            ; Blind 모드로 좌측 단어 선택
            Send("{Blind}^{Left}")
        }
        else
        {
            ; Visual Studio가 아니면 Ctrl+Shift+좌클릭 본연의 동작 수행
            Send("^+{LButton}")
        }
    }
    else
    {
        ; Ctrl이 완전히 안 눌렸다면: 마우스를 누르고 있는 동안 드래그(긁기)가 가능하도록 다운/업 처리
        Send("{Blind}{LButton Down}")
        KeyWait("LButton")
        Send("{Blind}{LButton Up}")
    }
}