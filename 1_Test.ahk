CapsLock & f::
    ; 현재 포커스가 있는 창의 텍스트 커서(Caret) 위치를 가져옵니다.
    ; 비주얼 스튜디오는 표준 윈도우 커서 좌표를 사용합니다.
    if (A_CaretX != "")
    {
        ; 커서 위치로 마우스 이동 (속도 0은 즉시 이동)
        MouseMove, A_CaretX, A_CaretY, 0
    }
    else
    {
        MsgBox, 커서 위치를 찾을 수 없습니다. (비주얼 스튜디오를 클릭한 후 시도하세요)
    }
return