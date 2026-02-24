#Requires AutoHotkey v2.0
#SingleInstance Force

#Numpad1:: 
{
    SendInput "#'"
    
    Sleep 90
    
    MouseGetPos &x, &y
    
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Yellow"
    myGui.SetFont("s50 cBlack bold", "Arial")  ; 크기 50
    myGui.Add("Text", "BackgroundRed cBlack", "  Here  ")
    myGui.Show("x" . (x - 80) . " y" . (y - 30) . " NoActivate") 
    
    SetTimer () => myGui.Destroy(), -150
}


;#':: {
;    SendInput "#'"
;}



