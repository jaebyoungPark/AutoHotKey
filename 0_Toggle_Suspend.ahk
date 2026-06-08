
$`::
{
    global MySuspended, HotkeyList
    global NumSuspended, NumPadSuspended
    global NumKeyList, NumPadKeyList

    start := A_TickCount
    toggled := false

    while GetKeyState("``", "P")
    {
        elapsed := A_TickCount - start

        ; ==================================================
        ; 230ms 넘는 순간 즉시 토글
        ; ==================================================
        if (!toggled && elapsed >= 230)
        {
            toggled := true

            ; 전체 토글 상태 반전 (On <-> Off)
            MySuspended := !MySuspended

            ; ==================================================
            ; [수정] 숫자키는 전체 상태와 동기화 (다시 켤 때 false가 되어 활성화)
            ; 넘패드는 기존처럼 강제 비활성화(true) 유지
            ; ==================================================
            NumSuspended    := MySuspended  ;전체 활성화시 false, 비활성화시 true
            NumPadSuspended := true         ;기존 유지

            ; UI 즉시 갱신
            UpdateStatusUI()

            ; ON / OFF 상태 문자열 지정
            state := MySuspended ? "Off" : "On"
            numState := NumSuspended ? "Off" : "On" ; 숫자키 전용 상태 문자열

            ; 일반 핫키 토글
            for key in HotkeyList
            {
                try {
                    Hotkey(key, "", state)
                }
                catch {
                }
            }

            ; ==================================================
            ; [수정] 숫자키 동적 활성화/비활성화 제어
            ; ==================================================
            for key in NumKeyList
            {
                try {
                    Hotkey(key, "", numState) ; 이제 켤 때는 "On"으로 들어갑니다.
                }
                catch {
                }
            }

            ; 넘패드는 무조건 강제 OFF 유지
            for key in NumPadKeyList
            {
                try {
                    Hotkey(key, "", "Off")
                }
                catch {
                }
            }

            ; 툴팁 및 사운드 출력
            ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON (NumKey Active)")
            SetTimer(() => ToolTip(), -100)

            if MySuspended
            {
                SoundPlay "C:\Windows\Media\Windows Critical Stop_Amplified.wav", 1
            }
            else
            {
                SoundPlay "C:\Windows\Media\notify_Amplified.wav", 1
            }

            break
        }

        Sleep 10
    }

    if (!toggled)
    {
        Send "{``}"
    }
}