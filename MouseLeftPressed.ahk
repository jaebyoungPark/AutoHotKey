#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================================================
; [기능 설명]
; ---------------------------------------------------------
; Win + 마우스 왼쪽 클릭(#LButton) 확장 스크립트
;
; 1. 일반 프로그램에서:
;
;    - Win + 좌클릭 시작 시:
;        → 마우스 왼쪽 버튼을 누른 상태로 유지
;
;    - 클릭 유지 시간에 따라 동작 분기:
;
;        ▷ 0.3초 미만
;           → 일반 클릭처럼 즉시 해제
;
;        ▷ 0.3초 ~ 0.8초
;           → 마우스 왼쪽 버튼 홀드 유지
;           → 커서 근처에 "눌림" 표시
;
;        ▷ 0.8초 초과
;           → 홀드 없이 그냥 해제
;
; 2. Visual Studio(devenv.exe)에서:
;
;    - Win + 좌클릭 시
;        → 먼저 실제 클릭 수행
;        → 이후 Ctrl + Left 전송
;
;    - 결과적으로:
;        → VS 코드 편집기에서
;          단어 단위 이동/선택 보조용으로 사용 가능
;
; 3. 추가 기능:
;
;    - ShowCursorText()
;        → 커서 주변에 ToolTip 표시
;
;    - IsHolding 변수
;        → 현재 마우스 홀드 상태 저장
;
; 4. 현재 주석 처리된 기능:
;
;    - 실제 좌클릭 시 홀드 해제
;    - ESC 키로 홀드 해제
;
;    해당 기능은
;    "1_Enter.ahk" 에서 처리 중이라 비활성화 상태.
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
    ; Visual Studio인지 확인
    if WinActive("ahk_exe devenv.exe")
    {
        ; 먼저 실제 클릭
        Click

        Sleep(30)

        ; 그 다음 Ctrl + Left
        Send("^{Left}")

        return
    }

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


;1_Enter.ahk 에 있어서 주석처리
; =========================
; 실제 LButton 클릭 시 홀드 해제
; =========================
; ~LButton::
; {
;     global IsHolding
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
;     if (IsHolding)
;     {
;         Send "{LButton Up}"
;         IsHolding := false
;         ShowCursorText("해제")
;     }
; }