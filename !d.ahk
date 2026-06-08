#Requires AutoHotkey v2.0

; $ 접두사는 Send("!d")가 이 단축키를 다시 트리거하는 무한 루프를 방지합니다.
$!d::
{
    ; Visual Studio인 경우만 한영키 제어 처리
    if WinActive("ahk_exe devenv.exe")
    {
        hwnd := WinGetID("A")
        
        ; v2 스타일의 내부 중첩 함수 (IME 상태 확인)
        IsKoreanMode(winHwnd) {
            if !(hIME := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", winHwnd, "Ptr"))
                return false
            res := DllCall("user32\SendMessage", "Ptr", hIME, "UInt", 0x0283, "UPtr", 1, "Ptr", 0, "Ptr")
            return (res & 1)
        }

        ; 현재 한글 모드라면 영어 모드로 전환
        if IsKoreanMode(hwnd)
        {
            Send("{vk15}") ; 한/영 키 입력
            Sleep(50)      ; 입력기 전환 안정성을 위한 딜레이
        }
    }

    ; 최종적으로 알트+d 입력 수행
    Send("!d")
}