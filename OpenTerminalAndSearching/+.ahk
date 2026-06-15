#Requires AutoHotkey v2.0
SplitPath(A_ScriptName, , , , &nameNoExt)
TargetDir := "E:\GitProject\AutoHotKey\AutoHotKey"

; 파워쉘이 정규식으로 오인하지 않도록 완전히 이스케이프 처리된 패턴 변수($pattern)를 정의합니다.
psCommand := "powershell.exe -NoExit -Command `"cd '" TargetDir "'; "
           . "$kw = '" nameNoExt "'; "
           . "$pattern = [regex]::Escape($kw); " ; 👈 특수문자(^, + 등)를 안전한 문자열로 변환
           . "function HL { param($line) $parts = $line -split $pattern; for ($i=0; $i -lt $parts.Count; $i++) { Write-Host $parts[$i] -NoNewline; if ($i -lt $parts.Count-1) { Write-Host $kw -NoNewline -ForegroundColor Black -BackgroundColor Yellow } } Write-Host '' }; "
           . "Write-Host '[1. FileName Match]' -ForegroundColor Cyan; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }; "
           . "Write-Host '`n[2. Hotkeys Found (Path Only)]' -ForegroundColor Yellow; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String -Pattern ('^\s*[~$^+#!<>]*' + $pattern + '\s*::') | Select-Object -ExpandProperty Path -Unique | ForEach-Object { HL $_ }; "
           . "Write-Host '`n[3. Modifier Match]' -ForegroundColor Magenta; "
           . "Get-ChildItem -Recurse -File | Select-String -Pattern ('\^' + $pattern) | ForEach-Object { HL $_.ToString() }`""

Run(psCommand)
ExitApp()