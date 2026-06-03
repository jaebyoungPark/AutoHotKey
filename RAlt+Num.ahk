#Requires AutoHotkey v2.0
#SingleInstance Force

; --- 전역 변수 설정 ---
; vk15를 누른 상태에서 다른 숫자 조합 키가 발동했는지 체크하는 플래그입니다.
global isComboTriggered := false

; 1. vk15 키를 '누를 때' (물결표 ~ 제거: 한/영 전환 기능 일단 차단)
vk15:: {
    global isComboTriggered := false ; 누를 때 플래그 초기화
    ShowDebug("vk15 누름 (조합 대기 중...)")
}

; 2. vk15 키를 '뗄 때' (Key-Up 이벤트)
vk15 up:: {
    global isComboTriggered
    ; 만약 숫자를 조합하지 않고, vk15(RAlt) 키만 단독으로 눌렀다 뗐다면 한/영 전환을 수행합니다.
    if (!isComboTriggered) {
        Send("{vk15}") 
        ShowDebug("vk15 단독 입력: 한/영 전환")
    } else {
        ShowDebug("조합 입력 완료: 한/영 전환 차단됨")
    }
}

; --- vk15 키를 누른 상태에서만 작동하는 핫키 구역 ---
#HotIf GetKeyState("vk15", "P")
$1:: HandleKey("1")
$2:: HandleKey("2")
$3:: HandleKey("3")
$4:: HandleKey("4")
$5:: HandleKey("5")
$6:: HandleKey("6")
$7:: HandleKey("7")
$8:: HandleKey("8")
$9:: HandleKey("9")
$0:: HandleKey("0")
#HotIf


; --- 기능을 수행하는 v2 함수들 ---
HandleKey(num) {
    global isComboTriggered := true ; 조합 키가 발동했음을 기록 (한/영 전환 방지용)
    SendInput(num)
    ShowDebug("vk15 + " num " 입력 성공!")
}

ShowDebug(message) {
    ToolTip("[디버깅] " message)
    SetTimer(() => ToolTip(), -1000)
}