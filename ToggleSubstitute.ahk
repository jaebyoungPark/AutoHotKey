#Requires AutoHotkey v2

; -----------------------------------------------------------------
; 블렌더가 활성화되어 있을 때는 아래 핫키를 무시하고 '원래 가운데 클릭'으로 작동
; -----------------------------------------------------------------
#HotIf !WinActive("ahk_exe blender.exe")

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

#HotIf ;HotIf 조건 초기화 (이하 다른 핫키에 영향 주지 않도록)