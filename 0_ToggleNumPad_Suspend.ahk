
#Requires AutoHotkey v2.0

; =========================================================
; [전체 구조 설명]
; =========================================================
; 이 스크립트는 "키를 짧게 누르면 원래 기능",
; "길게 누르면 특정 기능 토글" 구조로 되어 있음
;
; ---------------------------------------------------------
; 1) NumpadDot (. on numpad)
; ---------------------------------------------------------
; - 250ms 이상 누르고 있으면:
;      → NumPadSuspended 상태 토글
;      → NumPadKeyList에 있는 모든 핫키 ON/OFF 전환
;      → 상태에 따라 사운드 재생
;
; - 250ms 미만 짧게 누르면:
;      → 실제 Numpad Dot (.) 입력 그대로 전달
;
; ---------------------------------------------------------
; 2) F2
; ---------------------------------------------------------
; - 230ms 이상 누르고 있으면:
;      → NumSuspended 상태 토글
;      → NumKeyList에 있는 모든 핫키 ON/OFF 전환
;      → 상태에 따라 사운드 재생
;
; - 230ms 미만 짧게 누르면:
;      → 원래 F2 입력을 그대로 SendEvent로 전달
; =========================================================

; [경로 유연화] 스크립트 실행 폴더 내의 "Sounds" 폴더 지정
soundDir := A_ScriptDir "\Sounds\"


; ==========================================
; $NumpadDot: 넘패드 키 전용 토글
; ==========================================
$NumpadDot::
{
    ; 💡 넘패드 전용 변수와 리스트, 그리고 사운드 경로 변수 참조
    global NumPadSuspended, NumPadKeyList, soundDir

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

            ; [수정] 상대 경로가 적용된 Sounds 폴더 내부 조준
            if NumPadSuspended
                SoundPlay soundDir "Windows Critical Stop_Amplified.wav"
            else
                SoundPlay soundDir "notify_Amplified.wav"
        }

        Sleep 10
    }

    ; 짧게 탭했을 때만 . 입력
    if (!triggered)
        Send "{NumpadDot}"
}


; ==========================================
; $*F2: 일반 숫자 키 전용 토글
; ==========================================
$*F2::
{
    global NumSuspended, NumKeyList, soundDir

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

            ; [수정] 상대 경로가 적용된 Sounds 폴더 내부 조준
            SoundPlay NumSuspended
                ? soundDir "Windows Critical Stop_Amplified.wav"
                : soundDir "notify_Amplified.wav"
        }

        Sleep 10
    }

    ; 짧게 눌렀을 때만 우리가 직접 F2 전달
    if (!triggered)
    {
        SendEvent "{F2}"
    }
}