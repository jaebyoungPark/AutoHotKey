#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; Alt + IJKL → Alt 유지 + 방향키 (문구 제거)
; ==============================

!j::  ; Alt + J → Left
{
    Send("{Alt Down}{Left}")  ; Alt는 유지
}

!l::  ; Alt + L → Right
{
    Send("{Alt Down}{Right}") ; Alt는 유지
}

!i::  ; Alt + I → Up
{
    Send("{Alt Down}{Up}")    ; Alt는 유지
}

!k::  ; Alt + K → Down
{
    Send("{Alt Down}{Down}")  ; Alt는 유지
}