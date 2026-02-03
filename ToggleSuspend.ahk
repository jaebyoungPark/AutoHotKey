^+F9::{
    ; --------------------
    ; 디버깅: 처음에 ^^ 표시
    ; --------------------
    ToolTip "^^"
    SetTimer(() => ToolTip(), -200)  ; 0.2초 후 사라짐
    global MySuspended, HotkeyList
    start := A_TickCount  ; 누른 시각 기록
  
    while GetKeyState("F9", "P")
        Sleep 10  ; 10ms 간격으로 확인
    elapsed := A_TickCount - start  ; 누른 시간 계산
    
    if (elapsed >= 200 && elapsed < 800) {
        MySuspended := !MySuspended
        
        ; 에러 무시하고 토글
        for key in HotkeyList {
            try {
                Hotkey(key, "", MySuspended ? "Off" : "On")
            } catch {
                ; Up 핫키 등 제어 불가능한 것은 무시
            }
        }
        
; 🔊 사운드 (2음)
if MySuspended
{
    ; 🔒 OFF : 음정 ↓↓
    SoundBeep(1000, 90)
    SoundBeep(700, 90)
}
else
{
    ; 🔓 ON : 음정 ↑↑
    SoundBeep(700, 90)
    SoundBeep(1000, 90)
}
        ; 👁️ 토글 상태 문구 표시 (잠깐)
        ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON")
        SetTimer(() => ToolTip(), -800)
    }
    else if (elapsed < 250) {
        ; 짧게 누르면 Left
        SendInput("{Left}")
    }
}