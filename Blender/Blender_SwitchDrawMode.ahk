
; 파일명 : Blender_SwitchDrawMode.ahk

;=========================
; XP-Pen 설정시 유의사항
; Windows Ink를 체크해야 블렌더 페인팅에서 필압에 따라 Radius가 적용됨.
; Mouse Mode를 동시에 적용하면 화면 컨트롤 시 렉 또는 버벅임 발생.
; Mouse Mode만 켜면 필압이 적용되지 않으므로 블렌더 사용 시 반드시 꺼야 함.
; 결론 : Windows Ink만 켜서 사용.
;=========================

; Blender Sculpt Mode / Texture Paint Mode 전용
;
; Win + B    = 핫키 ON / OFF 토글
; D          + 마우스 이동 = 화면 회전 (MMB)
; Ctrl + D   + 마우스 이동 = 줌 (Ctrl + MMB)
; Shift + D  + 마우스 이동 = 평면 이동/팬 (Shift + MMB)

#Requires AutoHotkey v2.0
#SingleInstance Force

DrawModeHotkeysEnabled := false

; 사운드 파일 경로
OnSound := "E:\Programs\MyGits\AutoHotKey\Auto_HotKey\Sounds\notify.wav"
OffSound := A_WinDir "\Media\Windows Critical Stop.wav"


;=========================
; ON / OFF 토글
;=========================

#b::
{
    global DrawModeHotkeysEnabled, OnSound, OffSound

    DrawModeHotkeysEnabled := !DrawModeHotkeysEnabled

    if (DrawModeHotkeysEnabled)
    {
        SoundPlay(OnSound)
        ToolTip("Draw Mode: ON")
    }
    else
    {
        SoundPlay(OffSound)
        ToolTip("Draw Mode: OFF")
    }

    SetTimer(() => ToolTip(), -700)
}


;=========================
; Blender 현재 모드 확인
;=========================

IsBlenderDrawMode()
{
    modeFile := A_Temp "\blender_mode.txt"

    if !FileExist(modeFile)
        return false

    try
    {
        mode := FileRead(modeFile, "UTF-8")
        mode := Trim(mode)

        return (mode = "SCULPT" || mode = "PAINT_TEXTURE")
    }
    catch
    {
        return false
    }
}


;=========================
; Sculpt / Texture Paint 모드에서만 작동
;=========================

#HotIf DrawModeHotkeysEnabled && IsBlenderDrawMode() && WinActive("ahk_exe blender.exe")

*$d::
{
    SendEvent("{Blind}{MButton Down}")

    lastMods := GetKeyState("Ctrl", "P") "" GetKeyState("Shift", "P")

    while GetKeyState("d", "P")
    {
        curMods := GetKeyState("Ctrl", "P") "" GetKeyState("Shift", "P")

        if (curMods != lastMods)
        {
            SendEvent("{Blind}{MButton Up}")
            Sleep(10)
            SendEvent("{Blind}{MButton Down}")

            lastMods := curMods
        }

        Sleep(10)
    }

    SendEvent("{Blind}{MButton Up}")
}

#HotIf


;=========================
; Blender 모드 감지 Python 스크립트
;=========================

/*
import bpy
import os

MODE_FILE = os.path.join(os.environ["TEMP"], "blender_mode.txt")

last_mode = None


def update_blender_mode():
    global last_mode

    try:
        mode = bpy.context.mode

        if mode != last_mode:
            with open(MODE_FILE, "w", encoding="utf-8") as f:
                f.write(mode)

            last_mode = mode

    except Exception:
        pass

    return 0.2


if not bpy.app.timers.is_registered(update_blender_mode):
    bpy.app.timers.register(
        update_blender_mode,
        first_interval=0.2,
        persistent=True
    )
*/
