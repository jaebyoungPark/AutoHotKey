#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; [기능 설명]
; ---------------------------------------------------------
; Win / Ctrl + 마우스 버튼 조합 확장 스크립트
;
; ---------------------------------------------------------
; 1. Win + 좌클릭 (#LButton)
; ---------------------------------------------------------
;
; [일반 프로그램]
;
; - Win + 좌클릭 시작 시:
;     → 마우스 왼쪽 버튼을 누른 상태로 유지
;
; - 누르고 있던 시간에 따라 동작 분기:
;
;     ▷ 0.3초 미만
;        → 일반 클릭처럼 즉시 해제
;
;     ▷ 0.3초 ~ 0.8초
;        → 마우스 홀드 상태 유지
;        → 커서 근처에 "눌림" 표시
;
;     ▷ 0.8초 초과
;        → 자동 해제
;
;
; ---------------------------------------------------------
; 2. Win + 우클릭 (#RButton)
; ---------------------------------------------------------
;
; - 기존 우클릭 동작 그대로 수행
;
;
; ---------------------------------------------------------
; 3. Ctrl + 좌클릭 (^LButton)
; ---------------------------------------------------------
;
; [Visual Studio (devenv.exe)]
;
; - Ctrl 상태를 잠시 해제
; - 일반 클릭으로 포커스 확보
; - Ctrl + Left 전송
; - 필요 시 Ctrl 상태 복구
;
; 결과:
; → VS 코드 편집기에서
;   단어 단위 왼쪽 이동 보조 기능
;
; ※ Ctrl+클릭 정의 이동 방지 포함
;
;
; ---------------------------------------------------------
; 4. Ctrl + 우클릭 (^RButton)
; ---------------------------------------------------------
;
; [Visual Studio (devenv.exe)]
;
; - Ctrl 상태를 잠시 해제
; - 일반 클릭으로 포커스 확보
; - Ctrl + Right 전송
; - 필요 시 Ctrl 상태 복구
;
; 결과:
; → VS 코드 편집기에서
;   단어 단위 오른쪽 이동 보조 기능
;
;
; ---------------------------------------------------------
; 5. 보조 기능
; ---------------------------------------------------------
;
; - ShowCursorText()
;     → 커서 주변에 ToolTip 표시
;
; - IsHolding
;     → 현재 마우스 홀드 상태 저장
;
;
; ---------------------------------------------------------
; 6. 현재 비활성화된 기능
; ---------------------------------------------------------
;
; 아래 기능은 현재 주석 처리 상태:
;
; - 실제 좌클릭 시 홀드 해제
; - ESC 키 입력 시 홀드 해제
;
; 현재는
; "1_Enter.ahk"
; 에서 처리 중.
;
;
; ---------------------------------------------------------
; 7. 현재 홀드 해제 방법
; ---------------------------------------------------------
;
; 홀드 상태(IsHolding)일 때:
;
; - 마우스 왼쪽 버튼 클릭
; 또는
; - ESC 키 입력
;
; 시 마우스 홀드가 해제됨.
;
; 현재 해제 로직은
; "1_Enter.ahk"
; 에서 처리 중이라
; 이 파일에서는 주석 처리 상태.
;
; =========================================================

global LHoldStart := 0
global IsHolding := false

ShowCursorText(text, duration := 600)
{
    MouseGetPos &x, &y
    ToolTip text, x + 12, y + 12
    SetTimer () => ToolTip(), -duration
}

; =========================
; Win + LButton Down
; =========================
#LButton::
{
    global LHoldStart

    LHoldStart := A_TickCount
    Send "{LButton Down}"
}

; =========================
; Win + LButton Up
; =========================
#LButton Up::
{
    global LHoldStart, IsHolding

    holdTime := A_TickCount - LHoldStart

    ; 0.3초 미만 → 일반 클릭
    if (holdTime < 300)
    {
        Send "{LButton Up}"
        return
    }

    ; 0.3 ~ 0.8초 → 홀드 유지
    if (holdTime <= 800)
    {
        IsHolding := true
        ShowCursorText("눌림")
        return
    }

    ; 0.8초 초과 → 그냥 해제
    Send "{LButton Up}"
}

; =========================
; Win + RButton
; =========================
#RButton::
{
    ; 기존 우클릭 동작
    Send "{RButton}"
}

; =========================
; Ctrl + LButton
; =========================
^LButton::
{
    ; Visual Studio인 경우
    if WinActive("ahk_exe devenv.exe")
    {
        ; Ctrl 잠시 해제
        Send "{Ctrl Up}"

        ; 일반 클릭으로 포커스 확보
        Click

        Sleep(30)

        ; Ctrl + Left
        Send "^{Left}"

        ; 실제 Ctrl 누르고 있으면 복구
        if GetKeyState("Ctrl", "P")
        {
            Send "{Ctrl Down}"
        }

        return
    }

    ; 그 외 환경에서는 기본 좌클릭
    Send "{LButton}"
}

; =========================
; Ctrl + RButton
; =========================
^RButton::
{
    ; Visual Studio인 경우
    if WinActive("ahk_exe devenv.exe")
    {
        ; Ctrl 잠시 해제
        Send "{Ctrl Up}"

        ; 일반 클릭으로 포커스 확보
        Click

        Sleep(30)

        ; Ctrl + Right
        Send "^{Right}"

        ; 실제 Ctrl 누르고 있으면 복구
        if GetKeyState("Ctrl", "P")
        {
            Send "{Ctrl Down}"
        }

        return
    }

    ; 그 외 환경에서는 기본 우클릭
    Send "{RButton}"
}

;1_Enter.ahk 에 있어서 주석처리
; =========================
; 실제 LButton 클릭 시 홀드 해제
; =========================
; ~LButton::
; {
;     global IsHolding
;
;     if (IsHolding)
;     {
;         Send "{LButton Up}"
;         IsHolding := false
;         ShowCursorText("해제")
;     }
; }

; =========================
; Esc로도 홀드 해제
; =========================
; ~Esc::
; {
;     global IsHolding
;
;     if (IsHolding)
;     {
;         Send "{LButton Up}"
;         IsHolding := false
;         ShowCursorText("해제")
;     }
; }