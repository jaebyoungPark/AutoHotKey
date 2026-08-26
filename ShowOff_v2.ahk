#Requires AutoHotkey v2.0
#SingleInstance Force

; 멀티 모니터 DPI 차이로 인한 좌표 오차 방지 (Per-Monitor DPI Aware 선언)
DllCall("SetProcessDpiAwarenessContext", "ptr", -4)

CoordMode("Mouse", "Screen")

applicationname := "ShowOff"
inifile_path := applicationname . ".ini"

; 전역 변수 선언 (GUI와 Text 컨트롤을 배열로 관리)
global keyarray := []
global guiList := []
global textList := []
global backcolor, fontcolor, fontsize, boldness, fontName
global statusheight, statuswidth, statusx, statusy, relative, transparency, timetoshow
global statusOffTimer := () => StatusOff()

InitScript()

InitScript() {
    global guiList, textList
    global backcolor, fontcolor, fontsize, boldness, fontName
    global statusheight, statuswidth, statusx, statusy, relative, transparency, timetoshow

    TRAYMENU()
    READINI()

    boldOpt := (boldness >= 700) ? " Bold" : ""
    monCount := MonitorGetCount()

    ; 연결된 모든 모니터마다 GUI 생성
    Loop monCount {
        i := A_Index

        ; -DPIScale을 추가하여 배율에 관계없이 절대 픽셀 좌표 사용
        mGui := Gui("+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border +ToolWindow -DPIScale")
        mGui.MarginX := 0
        mGui.MarginY := 0
        mGui.BackColor := backcolor
        mGui.SetFont("c" . fontcolor . " s" . fontsize . boldOpt, fontName)

        tCtrl := mGui.Add("Text", "vtext", "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM")

        ; 각 모니터의 작업영역(픽셀) 가져오기
        MonitorGetWorkArea(i, &workLeft, &workTop, &workRight, &workBottom)

        ; 각 모니터의 Right/Bottom 기준으로 좌표 산출
        statusx_calc := workRight - statuswidth - 10
        statusy_calc := workBottom - statusheight - 10

        ; 화면 왼쪽/위쪽 경계를 넘지 않도록 안전 제한
        if (statusx_calc < workLeft + 10)
            statusx_calc := workLeft + 10

        if (statusy_calc < workTop + 10)
            statusy_calc := workTop + 10

        mGui.Show(
            "x" . statusx_calc
            . " y" . statusy_calc
            . " w" . statuswidth
            . " h" . statusheight
            . " NoActivate"
        )
        tCtrl.Value := ""

        if (transparency != "Off" && IsNumber(transparency)) {
            WinSetTransparent(Number(transparency), mGui.Hwnd)
        }

        guiList.Push(mGui)
        textList.Push(tCtrl)
    }

    SetTimer(MainLoop, 20)
}

MainLoop() {
    static oldkeys := ""
    static oldshiftkeys := ""
    
    keys := ""
    for key in keyarray {
        cleanKey := StrReplace(key, "`r", "")
        if (cleanKey == "")
            continue
        if (cleanKey == "AltGr"
            || cleanKey == "Break"
            || cleanKey == "CtrlBreak"
            || cleanKey == "Help")
            continue

        try {
            if GetKeyState(cleanKey, "P")
                keys .= " " . cleanKey
        }
        catch {
            continue
        }
    }
    keys := Trim(keys)

    if (keys == oldkeys)
        return

    shiftkeys := keys
    modifiers := ["LWin", "RWin", "LCtrl", "RCtrl", "LShift", "RShift", "LAlt", "RAlt", "AltGr", " "]
    for mod in modifiers {
        shiftkeys := StrReplace(shiftkeys, mod, "")
    }

    if (shiftkeys == "" && oldshiftkeys != "") {
        oldkeys := keys
        return
    }

    oldkeys := keys
    oldshiftkeys := shiftkeys

    if (keys != "") {
        ; 모든 모니터의 Text 컨트롤 업데이트
        for tCtrl in textList {
            tCtrl.Value := keys
        }
        SetTimer(statusOffTimer, -timetoshow)
    }

    ; GUI 드래그 이동 처리 (어느 모니터의 GUI를 잡고 드래그하든 동작)
    if GetKeyState("LButton", "P") {
        MouseGetPos(&mx1, &my1, &mid)
        for mGui in guiList {
            if (mid == mGui.Hwnd) {
                while GetKeyState("LButton", "P") {
                    MouseGetPos(&mx2, &my2)
                    WinGetPos(&sx, &sy, , , mGui.Hwnd)
                    sx := sx - mx1 + mx2
                    sy := sy - my1 + my2
                    WinMove(sx, sy, , , mGui.Hwnd)
                    mx1 := mx2
                    my1 := my2
                    Sleep(10)
                }
                break
            }
        }
    }
}

StatusOff() {
    ; 모든 모니터의 Text 컨트롤 지우기
    for tCtrl in textList {
        tCtrl.Value := ""
    }
}

READINI() {
    global

    if !FileExist(inifile_path) {
        FileAppend(
            ";ShowOff.ini`n"
            . "[Settings]`n"
            . "backcolor=FFFFFF`n"
            . "fontcolor=000000`n"
            . "fontsize=14`n"
            . "boldness=400`n"
            . "font=Arial`n"
            . "statusheight=30`n"
            . "statuswidth=320`n"
            . "statusx=10`n"
            . "statusy=10`n"
            . "relative=1`n"
            . "transparency=Off`n"
            . "timetoshow=1000`n`n",
            inifile_path
        )

        keys := [
            "AppsKey", "LWin", "RWin", "LCtrl", "RCtrl",
            "LShift", "RShift", "LAlt", "RAlt", "AltGr",
            "PrintScreen", "CtrlBreak", "Pause", "Break", "Help",
            "Browser_Back", "Browser_Forward", "Browser_Refresh",
            "Browser_Stop", "Browser_Search", "Browser_Favorites",
            "Browser_Home", "Volume_Mute", "Volume_Down", "Volume_Up",
            "Media_Next", "Media_Prev", "Media_Stop",
            "Media_Play_Pause", "Launch_Mail", "Launch_App1", "Launch_App2",
            "Launch_Media"
        ]

        Loop 24
            keys.Push("F" . A_Index)

        Loop 32
            keys.Push("Joy" . A_Index)

        keys.Push(
            "JoyX", "JoyY", "JoyZ", "JoyR", "JoyU", "JoyV", "JoyPOV",
            "Space", "Tab", "Enter", "Escape", "Backspace", "Delete",
            "Insert", "Home", "End", "PgUp", "PgDn",
            "Up", "Down", "Left", "Right",
            "ScrollLock", "CapsLock",
            "NumLock", "NumpadDiv", "NumpadMult",
            "NumpadAdd", "NumpadSub", "NumpadEnter",
            "NumpadDel", "NumpadIns", "NumpadClear", "NumpadDot"
        )

        Loop 10
            keys.Push("Numpad" . (A_Index - 1))

        Loop 26
            keys.Push(Chr(64 + A_Index))

        Loop 10
            keys.Push(A_Index == 10 ? "0" : A_Index)

        ; 특수문자
        keys.Push(
            ",", "%", "+", "-", "*", "\", "/", "|", "_",
            "<", "^", ">", "!", Chr(34), "#", "&", "(",
            ")", "=", "?", "'", "~", ";", ":", ".", "@", "$"
        )

        keys.Push(
            "LButton", "RButton", "MButton",
            "WheelDown", "WheelUp", "XButton1", "XButton2"
        )

        for key in keys
            FileAppend(key . "`n", inifile_path)
    }

    backcolor := IniRead(inifile_path, "Settings", "backcolor", "FFFFFF")
    fontcolor := IniRead(inifile_path, "Settings", "fontcolor", "000000")
    fontsize := Number(IniRead(inifile_path, "Settings", "fontsize", "14"))
    boldness := Number(IniRead(inifile_path, "Settings", "boldness", "400"))
    fontName := IniRead(inifile_path, "Settings", "font", "Arial")

    statusheight := Number(IniRead(inifile_path, "Settings", "statusheight", "30"))
    statuswidth := Number(IniRead(inifile_path, "Settings", "statuswidth", "320"))
    statusx := Number(IniRead(inifile_path, "Settings", "statusx", "10"))
    statusy := Number(IniRead(inifile_path, "Settings", "statusy", "10"))

    relative := IniRead(inifile_path, "Settings", "relative", "1")
    transparency := IniRead(inifile_path, "Settings", "transparency", "Off")
    timetoshow := Number(IniRead(inifile_path, "Settings", "timetoshow", "1000"))

    rawText := FileRead(inifile_path)
    keyarray := []

    for line in StrSplit(rawText, "`n", "`r") {
        line := Trim(line)

        if (
            line == ""
            || SubStr(line, 1, 1) == ";"
            || SubStr(line, 1, 1) == "["
            || InStr(line, "=")
        )
            continue

        keyarray.Push(line)
    }
}

TRAYMENU() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add(applicationname, (*) => SETTINGS())
    A_TrayMenu.Add()
    A_TrayMenu.Add("&Settings...", (*) => SETTINGS())
    A_TrayMenu.Add("&About...", (*) => ABOUT())
    A_TrayMenu.Add("E&xit", (*) => ExitApp())
    A_TrayMenu.Default := applicationname
    A_TrayMenu.ClickCount := 1
}

SETTINGS() {
    if FileExist(inifile_path)
        Run(inifile_path)
}

ABOUT() {
    ; 첫 번째 모니터 GUI를 Owner로 지정 (없을 경우 0)
    ownerHwnd := (guiList.Length > 0) ? guiList[1].Hwnd : 0
    aboutGui := Gui("+Owner" . ownerHwnd, applicationname . " About")
    aboutGui.MarginX := 20
    aboutGui.MarginY := 20

    aboutGui.Add("Text", "FontBold", applicationname . " v1.0")
    aboutGui.Add("Text", "y+5", "Shows pushed down keys and buttons")
    aboutGui.Add("Text", "y+2", "- To change the look of the status window, edit the " . applicationname . ".ini")
    aboutGui.Add("Text", "y+0", "  by rightclicking the tray menu and selecting Settings")

    aboutGui.Add("Text", "y+15 FontBold", "1 Hour Software by Skrommel")
    aboutGui.Add("Text", "y+2", "For more tools, information and donations, please visit")
    link1 := aboutGui.Add("Text", "y+2 cBlue Section", "www.1HourSoftware.com")
    link1.OnEvent("Click", (*) => Run("http://www.1hoursoftware.com"))

    aboutGui.Add("Text", "y+15 FontBold", "DonationCoder")
    aboutGui.Add("Text", "y+2", "Please support the contributors at")
    link2 := aboutGui.Add("Text", "y+2 cBlue Section", "www.DonationCoder.com")
    link2.OnEvent("Click", (*) => Run("http://www.donationcoder.com"))

    aboutGui.Add("Text", "y+15 FontBold", "AutoHotkey")
    aboutGui.Add("Text", "y+2", "This tool was made using the powerful")
    link3 := aboutGui.Add("Text", "y+2 cBlue Section", "www.AutoHotkey.com")
    link3.OnEvent("Click", (*) => Run("http://www.autohotkey.com"))

    aboutGui.Show()
}