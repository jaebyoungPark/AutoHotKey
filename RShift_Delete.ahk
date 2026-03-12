#Requires AutoHotkey v2.0
#SingleInstance Force

RShift & Tab::
{
    Send "{Delete}"

    ToolTip "🗑 Delete 실행"
    SetTimer(() => ToolTip(), -500)
}

RShift & CapsLock::
{
    Send "{Backspace}"

    ToolTip "⌫ Backspace 실행"
    SetTimer(() => ToolTip(), -500)
}