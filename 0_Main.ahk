; 메인 스크립트

#Include 0_Includes.ahk



MySuspended := false



HotKeyList := ["RButton", "$XButton1", "^+WheelUp","^+WheelDown","$^1", "$^2", "^3", "^4", "$^+=", "^!+p", "^!+o", "$^+a", "^+1","^+2","^+3","^+4", "!WheelUp", "!WheelDown", "XButton2", "!LButton", "!RButton", "^!WheelUp", "^!WheelDown", "$MButton", "^+F10", "+!1", "+WheelUp", "+WheelDown", "^LButton", "^RButton", "!Left", "!Right", "!+Right", "!+Left", "+!LButton", "+!RButton", "^LButton", "^Left", "^Right", "^+Right", "^+Left" "#,", "#.", "#[", "#]", "#Left", "#Right", "#Up", "#Down", "#^Left", "#^Right", "#^Up", "#^Down",  "~LButton", "^Up", "^!Enter Up", "^Down", "~LWin", "~RWin", "~Esc", "#\", "#0", "#NumpadEnter Up", "#PgDn", "#PgUp", "^!Up", "^!Down", "PgUp", "PgDn", "^PgUp", "^PgDown", "^NumpadEnter", "^Enter", "$Left", "$Right", "^Numpad1", "^Numpad2", "^!NumpadEnter", "!NumpadEnter", "Up", "Down", "Left", "Right", "+Left", "+Right", "#z", "#LButton", "+!0", "#NumpadDot", "^NumpadDot"]

;, "^+F11" (GoLeft) 는 토글용이기도 하므로 일부러 핫키에 안넣음
