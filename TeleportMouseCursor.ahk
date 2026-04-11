marginX := 120  ; 좌우 여백
marginY := 120  ; 상하 여백

; =========================
; 📌 중앙
; =========================
vk19 & s:: {
    MouseMove A_ScreenWidth // 2, A_ScreenHeight // 2, 0
}

; =========================
; 📌 코너 (Q E Z C)
; =========================
vk19 & q:: { ; 왼쪽 상단
    MouseMove marginX, marginY, 0
}

vk19 & e:: { ; 오른쪽 상단
    MouseMove A_ScreenWidth - marginX, marginY, 0
}

vk19 & z:: { ; 왼쪽 하단
    MouseMove marginX, A_ScreenHeight - marginY, 0
}

vk19 & c:: { ; 오른쪽 하단
    MouseMove A_ScreenWidth - marginX, A_ScreenHeight - marginY, 0
}

; =========================
; 📌 십자 방향 (W A D X)
; =========================

vk19 & w:: { ; 위 (상단 중앙)
    MouseMove A_ScreenWidth // 2, marginY, 0
}

vk19 & x:: { ; 아래 (하단 중앙)
    MouseMove A_ScreenWidth // 2, A_ScreenHeight - marginY, 0
}

vk19 & a:: { ; 왼쪽 (좌측 중앙)
    MouseMove marginX, A_ScreenHeight // 2, 0
}

vk19 & d:: { ; 오른쪽 (우측 중앙)
    MouseMove A_ScreenWidth - marginX, A_ScreenHeight // 2, 0
}