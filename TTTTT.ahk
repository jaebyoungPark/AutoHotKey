#Requires AutoHotkey v2.0
#SingleInstance Force

; 관리자 권한 필요 (pnputil이 요구함)
if !A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

; Ctrl+Alt+M : 디스플레이 어댑터 재시작 -> 모니터 강제 재검색
^!m::RestartDisplayAdapters()

RestartDisplayAdapters() {
    TrayTip("모니터 재검색", "디스플레이 어댑터를 재시작합니다...", 1)

    psScript := '
    (
        $gpus = Get-PnpDevice -Class Display -Status OK
        foreach ($gpu in $gpus) {
            Write-Host "Restarting:" $gpu.FriendlyName
            pnputil /restart-device "$($gpu.InstanceId)"
        }
    )'

    tempFile := A_Temp "\restart_display.ps1"
    if FileExist(tempFile)
        FileDelete(tempFile)
    FileAppend(psScript, tempFile, "UTF-8")

    RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' tempFile '"', , "Hide")

    FileDelete(tempFile)
    TrayTip("완료", "재검색이 끝났습니다. 화면이 깜빡였다면 정상입니다.", 1)
}