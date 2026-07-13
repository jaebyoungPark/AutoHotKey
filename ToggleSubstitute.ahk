#Requires AutoHotkey v2

; -----------------------------------------------------------------
; 마우스 커서 아래에 있는 창이 블렌더가 아닐 때만 아래 핫키 활성화
; -----------------------------------------------------------------
#HotIf !MouseIsOver("ahk_exe blender.exe")

$MButton:: {
    start := A_TickCount
    KeyWait("MButton")

    elapsed := (A_TickCount - start)/1000

    ; --- 활성 창이 없을 경우 대비 ---
    try title := WinGetTitle("A")
    catch {
        Click("M")
        return
    }

    ; ------------------------------
    ; Udemy 환경
    ; ------------------------------
    if InStr(title, "Udemy") {
        if (elapsed >= 0.25 && elapsed <= 0.5) {
            Send "c"
            return
        }
    }
    ; ------------------------------
    ; uTorrent 환경
    ; ------------------------------
    else if WinActive("ahk_exe uTorrent.exe") {
        if (elapsed >= 0.25 && elapsed <= 0.5) {
            Send "N"
            Sleep 50
            Send "E"
            return
        }
    }

    ; ------------------------------
    ; 그 외 환경 → 기본 가운데 클릭
    ; ------------------------------
    Click("M")
}

#HotIf ; HotIf 조건 초기화

; --- 마우스 커서 아래의 창을 감지하는 함수 ---
MouseIsOver(WinTitle) {
    MouseGetPos ,, &Win
    return WinExist(WinTitle " ahk_id " Win)
}