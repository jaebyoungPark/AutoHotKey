RShift:: {
    if GetKeyState("CapsLock", "T")
        SetCapsLockState "Off"
    else
        SetCapsLockState "On"
    KeyWait "RShift"
}