#Requires AutoHotkey v2.0

HotkeyList := ["$XButton1"]

ShowBigEnd() {
    static endGui := 0

    if endGui {
        endGui.Destroy()
        endGui := 0
    }

    endGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    endGui.BackColor := "Black"
    endGui.SetFont("s48 Bold", "Segoe UI")
    endGui.AddText("cRed Center w400 h120", "END")

    ; 화면 중앙
    x := (A_ScreenWidth - 400) // 2
    y := (A_ScreenHeight - 120) // 2
    endGui.Show("x" x " y" y " NoActivate")

    ; 0.6초 후 자동 제거
    SetTimer(() => (
        endGui.Destroy(),
        endGui := 0
    ), -100)
}

$XButton1:: {
    start := A_TickCount

    if !KeyWait("XButton1", "T0.5") {
        ShowBigEnd()
        return
    }

    elapsed := A_TickCount - start

    if (elapsed < 250) {
        Send "{XButton1}"
    }
    else {
        if WinActive("ahk_exe GOM64.EXE") {
            Send "!{F4}"
        } else {
            Send "^w"
        }
    }
}