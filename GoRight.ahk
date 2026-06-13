;---------------------------------
; Ctrl + Shift + =  → Right (마우스 오버 활성화 적용)
; AHK v2
;---------------------------------

$^+=:: {
    ; 🎯 마우스 커서 아래에 있는 창의 ID(HWND) 획득
    MouseGetPos ,, &mouseHwnd

    ; 마우스 아래에 유효한 창이 존재하는지 검사 (에러 방지)
    if WinExist("ahk_id " mouseHwnd) {
        ; 🌟 [공용 함수 활용] 마우스 아래 창을 안전하고 확실하게 활성화!
        EnsureWindowActive(mouseHwnd)
        Sleep 50 ; ⚡ 창이 포커스를 완전히 수신할 수 있도록 미세 버퍼 제공
        
        SendInput("{Right}")
    } else {
        ; 혹시라도 타겟 창을 못 잡았다면 기본 Right 키 전송
        SendInput("{Right}")
    }
}