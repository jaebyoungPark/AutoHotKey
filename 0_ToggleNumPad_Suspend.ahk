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

; ==========================================
; $F2: 일반 숫자 키 전용 토글
; ==========================================
$F2::
{
    ; 💡 일반 숫자 전용 변수(NumSuspended)와 리스트(NumKeyList) 사용
    global NumSuspended, NumKeyList

    start := A_TickCount
    triggered := false

    while GetKeyState("F2", "P")
    {
        if (!triggered && (A_TickCount - start >= 230))
        {
            triggered := true

            ; 일반 숫자 상태 반전
            NumSuspended := !NumSuspended

            for key in NumKeyList
            {
                try {
                    ; 💡 v2 올바른 문법: 두 번째 매개변수에 On/Off를 직접 지정
                    Hotkey(key, NumSuspended ? "Off" : "On")
                } catch {
                    ; 예외 무시
                }
            }

            SoundPlay NumSuspended
                ? "C:\Windows\Media\Windows Critical Stop_Amplified.wav"
                : "C:\Windows\Media\notify_Amplified.wav"
        }

        Sleep 10
    }

    ; 짧게 탭했을 때만 F2 입력
    if (!triggered)
        Send "{F2}"
}