; 파일명 : Blender_SwitchDrawMode.ahk

;=========================
; XP-Pen 설정시 유의사항
; 내 XP-Pen 설정에서 정말 중요한 점. Window Ink 를 체크해야만 블렌더 페인팅에서 필압에 따라 radius 가 적용됨. 마우스 모드를 동시에 적용하면
; 커서 이동은 편하지만, 치명적인 문제가 있는데 화면 컨트롤 시 렉 또는 버벅임이 발생함.
; 마우스 모드만 켜면 radius 등 필압적용 안되므로 블렌더 사용시 무조건 꺼야됨.
; 결론 : 불편하더라도 window ink 만 켜라. 코드에는 문제가 없다.
;=========================

; Blender Sculpt Mode / Texture Paint Mode 전용
;
; D          + 마우스 이동 = 화면 회전 (MMB)
; Ctrl + D   + 마우스 이동 = 줌 (Ctrl + MMB)
; Shift + D  + 마우스 이동 = 평면 이동/팬 (Shift + MMB)

#Requires AutoHotkey v2.0
#SingleInstance Force


; Blender 현재 모드 확인
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


; Sculpt / Texture Paint 모드에서만 작동
#HotIf IsBlenderDrawMode() && WinActive("ahk_exe blender.exe")

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

; 중요) 위의 코드는 정상작동한다. 다만, 블렌더의의 스크립팅에서 아래를 실행해야만 가능함
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