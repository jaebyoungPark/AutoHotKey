#Requires AutoHotkey v2


$MButton:: {
    start := A_TickCount
    KeyWait("MButton")

    elapsed := (A_TickCount - start)/1000

    ; --- 활성 창이 없을 경우 대비 ---
    try title := WinGetTitle("A")
    catch {
        Click("M")   ; 창 없으면 그냥 기본 동작
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