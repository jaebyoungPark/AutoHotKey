#HotIf WinActive("ahk_exe blender.exe")

$Backspace::
{
    ; 0.2초 동안 눌려있는지 확인
    if KeyWait("Backspace", "T0.2")
    {
        ; 0.2초 안에 뗌 → Backspace
        Send "{Backspace}"
    }
    else
    {
        ; 0.2초 이상 누름 → 뗄 때까지 기다림
        KeyWait "Backspace"

        ToolTip "🗑 Delete"
        SetTimer () => ToolTip(), -300

        Send "{Delete}"
    }
}

#HotIf