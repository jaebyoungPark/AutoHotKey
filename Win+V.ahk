; WIN + V -> 마우스 오른쪽 클릭 (뗄 때 동작) + 툴팁
#v:: {
    KeyWait "v"                  ; V 키를 뗄 때까지 대기
    Send "{RButton down}{RButton up}"  ; 마우스 오른쪽 버튼 눌렀다 떼기
    ToolTip "오른쪽 클릭"
    SetTimer () => ToolTip(), -500
}