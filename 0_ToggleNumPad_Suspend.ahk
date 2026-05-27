#Requires AutoHotkey v2.0

; ==========================================
; $NumpadDot: 넘패드 키 전용 토글
; ==========================================
$NumpadDot::
{
    ; 💡 넘패드 전용 변수(NumPadSuspended)와 리스트(NumPadKeyList) 사용
    global NumPadSuspended, NumPadKeyList

    start := A_TickCount
    triggered := false

    while GetKeyState("NumpadDot", "P")
    {
        if (!triggered && (A_TickCount - start >= 250))
        {
            triggered := true

            ; 넘패드 상태 반전
            NumPadSuspended := !NumPadSuspended

            for key in NumPadKeyList
            {
                try {
                    ; 💡 v2 올바른 문법: 두 번째 매개변수에 On/Off를 직접 지정
                    Hotkey(key, NumPadSuspended ? "Off" : "On")
                } catch {
                    ; 예외 무시
                }
            }

            if NumPadSuspended
                SoundPlay "C:\Windows\Media\Windows Critical Stop_Amplified.wav"
            else
                SoundPlay "C:\Windows\Media\notify_Amplified.wav"
        }

        Sleep 10
    }

    ; 짧게 탭했을 때만 . 입력
    if (!triggered)
        Send "{NumpadDot}"
}

#Requires AutoHotkey v2.0

$*F2::
{
    global NumSuspended, NumKeyList

    start := A_TickCount
    triggered := false

    ; 원본 F2 차단
    KeyWait "F2", "T0"

    while GetKeyState("F2", "P")
    {
        if (!triggered && (A_TickCount - start >= 230))
        {
            triggered := true

            NumSuspended := !NumSuspended

            for key in NumKeyList
            {
                try {
                    Hotkey(key, NumSuspended ? "Off" : "On")
                }
            }

            SoundPlay NumSuspended
                ? "C:\Windows\Media\Windows Critical Stop_Amplified.wav"
                : "C:\Windows\Media\notify_Amplified.wav"
        }

        Sleep 10
    }

    ; 짧게 눌렀을 때만 우리가 직접 F2 전달
    if (!triggered)
    {
        SendEvent "{F2}"
    }
}