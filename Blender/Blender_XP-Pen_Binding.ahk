#Requires AutoHotkey v2.0

;파일명 : Blender_XP-Pen_Binding.ahk

; OpenTabletDriver 프로그램에서 Pen Binding 1 과 2 에 마우스 backward 나 forward 를 설정해도 안먹히므로, 오토핫키에서 가상의 키 F13, F14를
; 만들고, 위 프로그램에서 Key Binding: (Key: F13), Key Binding: (Key: F14) 를 설정함.


F13::
{
    Send "!{Right}"
}

F14::
{
    Send "!{Left}"
}