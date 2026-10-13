#Requires AutoHotkey v2.0

; [핵심] 오토핫키 파일과 분리되어 닉네임만 모아둘 텍스트 파일 이름
blockedFile := A_Desktop . "\my_youtube_blocked_nicknames.txt"

; 단축키: Ctrl + Shift + X
^+x:: {
    global blockedFile
    
    nick := Trim(A_Clipboard)
    if (nick = "") {
        MsgBox("클립보드에 복사된 텍스트가 없습니다. 유튜브 닉네임을 복사한 후 단축키를 눌러주세요.")
        return
    }

    ; 텍스트 파일이 이미 존재한다면 중복 체크
    if FileExist(blockedFile) {
        existingContent := FileRead(blockedFile, "UTF-8")
        if InStr(existingContent, nick) {
            MsgBox("이미 차단 목록에 있는 닉네임입니다: " . nick)
            return
        }
    }

    ; 바탕화면에 순수 닉네임만 적힐 텍스트 파일에 추가
    FileAppend(nick . "`n", blockedFile, "UTF-8")
    MsgBox("차단 목록에 추가되었습니다: " . nick)
}