#Requires AutoHotkey v2.0

; "Yes/No" 버튼과 물음표 아이콘(?)을 가진 알림창을 띄웁니다.
result := MsgBox("컴퓨터를 절전 모드로 전환하시겠습니까?", "절전 모드 확인", "YesNo Icon?")

; 사용자가 "Yes(예)"를 선택했을 때만 절전 모드 명령을 실행합니다.
if (result = "Yes") {
    DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}