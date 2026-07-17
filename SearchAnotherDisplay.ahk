#Requires AutoHotkey v2.0
#SingleInstance Force

; F12 키를 누르면 실행 (원하는 단축키로 변경 가능)
F12:: {
    ; 1. 윈도우 디스플레이 설정 창 실행
    Run("ms-settings:display")
    
    ; 2. 설정 창이 활성화될 때까지 최대 3초 대기
    if WinWaitActive("ahk_class ApplicationFrameWindow", , 3) {
        Sleep 800 ; 창이 완전히 로딩되고 안정화될 때까지 잠시 대기
        
        ; 3. 창 내부에서 '검색' (또는 영문 'Detect') 텍스트를 가진 컨트롤을 찾아 클릭
        ;    (윈도우 10/11 시스템 언어가 한글이면 "검색", 영문이면 "Detect"로 자동 대응)
        if WinActive("ahk_class ApplicationFrameWindow") {
            ; 한글 윈도우용 "검색" 버튼 클릭 시도
            try ControlClick("검색", "A")
            ; 영문 윈도우용 "Detect" 버튼 클릭 시도
            try ControlClick("Detect", "A")
        }
        
        Sleep 500 ; 클릭 연산이 들어갈 시간 대기
        
        ; 4. 작업 완료 후 설정 창 닫기 (원치 않으면 아래 줄을 지우거나 주석 처리하세요)
        WinClose("A")
    }
}