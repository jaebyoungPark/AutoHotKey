; ============================================================
; Shift + Alphabet: Only the first letter is uppercase.
; Releasing Shift resets the state.
; AutoHotkey v2
; ============================================================

global ShiftFirstLetterUsed := false

; Reset state when LShift is released
~LShift Up:: {
    global ShiftFirstLetterUsed
    ShiftFirstLetterUsed := false
}

#HotIf GetKeyState("LShift", "P") && !GetKeyState("Ctrl", "P") && !GetKeyState("Alt", "P") && !GetKeyState("LWin", "P") && !GetKeyState("RWin", "P")

*a::HandleShiftLetter("a")
*b::HandleShiftLetter("b")
*c::HandleShiftLetter("c")
*d::HandleShiftLetter("d")
*e::HandleShiftLetter("e")
*f::HandleShiftLetter("f")
*g::HandleShiftLetter("g")
*h::HandleShiftLetter("h")
*i::HandleShiftLetter("i")
*j::HandleShiftLetter("j")
*k::HandleShiftLetter("k")
*l::HandleShiftLetter("l")
*m::HandleShiftLetter("m")
*n::HandleShiftLetter("n")
*o::HandleShiftLetter("o")
*p::HandleShiftLetter("p")
*q::HandleShiftLetter("q")
*r::HandleShiftLetter("r")
*s::HandleShiftLetter("s")
*t::HandleShiftLetter("t")
*u::HandleShiftLetter("u")
*v::HandleShiftLetter("v")
*w::HandleShiftLetter("w")
*x::HandleShiftLetter("x")
*y::HandleShiftLetter("y")
*z::HandleShiftLetter("z")

#HotIf

HandleShiftLetter(letter) {
    global ShiftFirstLetterUsed

    if (ShiftFirstLetterUsed) {
        ; Type lowercase letters after the first letter
        SendInput "{Blind}{Shift up}"
        SendInput letter

        ; Restore the physical LShift state
        if GetKeyState("LShift", "P")
            SendInput "{Blind}{LShift down}"
    } else {
        ; Type the first letter in uppercase
        SendInput "{Blind}{Shift up}"
        SendInput StrUpper(letter)

        ; Restore the physical LShift state
        if GetKeyState("LShift", "P")
            SendInput "{Blind}{LShift down}"

        ; Show tooltip
        ToolTip "Shift + " StrUpper(letter) " → Uppercase"
        SetTimer(() => ToolTip(), -700)
    }

    ShiftFirstLetterUsed := true
}