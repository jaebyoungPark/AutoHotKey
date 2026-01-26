#Requires AutoHotkey v2.0
#SingleInstance Force

#Numpad0::  ; Win + NumPad0
{
    SendInput "#'"
    
    Sleep 50
    
    MouseGetPos &x, &y
    
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    myGui.BackColor := "Red"
    myGui.SetFont("s50 cBlack bold", "Arial")  ; 크기 50
    myGui.Add("Text", "BackgroundRed cBlack", "  Here  ")
    myGui.Show("x" . (x - 80) . " y" . (y - 30) . " NoActivate")
    
    SetTimer () => myGui.Destroy(), -100
}