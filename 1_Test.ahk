#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================
; 설정값
; ==============================
MoveAmount := 20  ; 한 번 움직일 픽셀 수

; ==============================
; 우측 한자키(RAlt) + a → 마우스 왼쪽 이동
; ==============================
<^>!a::  ; <^>! 은 우측 Alt (한자키) 를 의미
{
    MouseGetPos &x, &y  ; 현재 마우스 위치 가져오기
    x -= MoveAmount      ; 왼쪽으로 이동
    MouseMove x, y, 0    ; 0 = 즉시 이동
    return
}