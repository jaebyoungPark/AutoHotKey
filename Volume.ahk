#Requires AutoHotkey v2.0

ShowVolumeTip(text) {
    ToolTip text
    SetTimer(() => ToolTip(), -500)  ; 0.5초 후 사라짐
}

; Ctrl + Shift + 휠 업 → 볼륨 업
^+WheelUp:: {
    Send "{Volume_Up}"
    ShowVolumeTip("🔊 Volume Up")
}

; Ctrl + Shift + 휠 다운 → 볼륨 다운
^+WheelDown:: {
    Send "{Volume_Down}"
    ShowVolumeTip("🔉 Volume Down")
}

; Ctrl + Shift + Home → 볼륨 업
^+Home:: {
    Send "{Volume_Up}"
    ShowVolumeTip("🔊 Volume Up")
}

; Ctrl + Shift + Ins → 볼륨 다운
^+Ins:: {
    Send "{Volume_Down}"
    ShowVolumeTip("🔉 Volume Down")
}