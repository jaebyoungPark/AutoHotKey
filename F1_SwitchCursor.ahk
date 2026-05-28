; 단축키 앞에 $를 붙여 Send "{F1}"이 자기 자신을 다시 트리거하는 것을 방지합니다.
$F1::
{
    ; ==================================================
    ; 개발 환경 (Unreal / Visual Studio) - 비활성 (주석 유지)
    ; ==================================================
    ; if (
    ;        WinActive("ahk_exe UE4Editor.exe")
    ;     || WinActive("ahk_exe UnrealEditor.exe")
    ;     || InStr(WinGetTitle("A"), "Unreal Editor")
    ;     || WinActive("ahk_class UnrealWindow")
    ;     || WinActive("ahk_exe devenv.exe")
    ; ) {
    ;     ToolTip "🟣 Dev Mode : Mouse Teleport (/)"
    ;     SetTimer () => ToolTip(), -300
    ;
    ;     MoveMouseToOtherMonitor()
    ;     return
    ; }

    ; ==================================================
    ; 즉시 실행 logic
    ; ==================================================
    ; F1 키를 누른 즉시 마우스를 다른 모니터로 이동합니다.
    MoveMouseToOtherMonitor()
}