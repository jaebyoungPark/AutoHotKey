$`::
{
    global MySuspended, HotkeyList
    global NumSuspended, NumPadSuspended
    global NumKeyList, NumPadKeyList
    global soundDir  ; [추가] 사운드 상대 경로 변수 전역 참조

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
            ; 숫자키는 전체 상태와 동기화
            ; 넘패드는 항상 비활성화
            ; ==================================================
            NumSuspended := MySuspended
            NumPadSuspended := true

            ; UI 즉시 갱신
            UpdateStatusUI()

            ; ON / OFF 상태 문자열 지정
            state := MySuspended ? "Off" : "On"
            numState := NumSuspended ? "Off" : "On"

            ; ==================================================
            ; 일반 핫키 토글
            ; ==================================================
            for key in HotkeyList
            {
                try Hotkey(key, "", state)
            }

            ; hotkeylist에 안 먹는 F2 별도 처리
            try Hotkey("$*F2", "", state)

            ; ==================================================
            ; 숫자키 동적 활성화/비활성화
            ; ==================================================
            for key in NumKeyList
            {
                try Hotkey(key, "", numState)
            }

            ; ==================================================
            ; 넘패드는 항상 OFF
            ; ==================================================
            for key in NumPadKeyList
            {
                try Hotkey(key, "", "Off")
            }

            ; ==================================================
            ; UI 및 사운드
            ; ==================================================
            ToolTip(MySuspended ? "🔒 Hotkey OFF" : "🔓 Hotkey ON (NumKey Active)")
            SetTimer(() => ToolTip(), -100)

            ; [수정] 상대 경로가 적용된 Sounds 폴더 내부를 조준하도록 변경
            if MySuspended
                SoundPlay(soundDir "Windows Critical Stop_Amplified.wav", 1)
            else
                SoundPlay(soundDir "notify_Amplified.wav", 1)

            break
        }

        Sleep(10)
    }

    if !toggled
    {
        Send("{``}")
    }
}