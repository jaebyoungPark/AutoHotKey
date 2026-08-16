#Requires AutoHotkey v2.0
#SingleInstance Force

if !A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

MsgBox("스크립트 시작됨 (관리자 권한 OK)")

^!m::RestartDisplayAdapters()

RestartDisplayAdapters() {
    MsgBox("핫키 눌림, 재검색 시작")

    psScript := '
    (
        $gpus = Get-PnpDevice -Class Display -Status OK
        foreach ($gpu in $gpus) {
            Write-Output "Restarting: $($gpu.FriendlyName) / $($gpu.InstanceId)"
            pnputil /restart-device "$($gpu.InstanceId)"
        }
    )'

    tempFile := A_Temp "\restart_display.ps1"
    if FileExist(tempFile)
        FileDelete(tempFile)
    FileAppend(psScript, tempFile, "UTF-8")

    outFile := A_Temp "\restart_display_out.txt"
    if FileExist(outFile)
        FileDelete(outFile)

    RunWait('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' tempFile '" *> "' outFile '"', , "Hide")

    result := FileExist(outFile) ? FileRead(outFile, "UTF-8") : "출력 파일 없음"
    MsgBox("결과:`n" result)

    FileDelete(tempFile)
}