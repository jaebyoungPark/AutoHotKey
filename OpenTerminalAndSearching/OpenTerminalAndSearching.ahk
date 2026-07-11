#Requires AutoHotkey v2.0
TargetDir := "E:\Programs\MyGits\AutoHotKey\AutoHotKey"

; 🔍 찾고 싶은 키워드
kw := "tab"

; 파워쉘 문자열 내에서 홑따옴표(')가 충돌하지 않도록 두 개('')로 치환하여 이스케이프 처리합니다. ★핵심
safeKw := StrReplace(kw, "'", "''")

psCommand := "powershell.exe -NoExit -Command `"cd '" TargetDir "'; "
           . "$kw = '" safeKw "'; "
           . "$pattern = [regex]::Escape($kw); " 
           . "function HL { param($line) $parts = $line -split $pattern; for ($i=0; $i -lt $parts.Count; $i++) { Write-Host $parts[$i] -NoNewline; if ($i -lt $parts.Count-1) { Write-Host '" safeKw "' -NoNewline -ForegroundColor Black -BackgroundColor Yellow } } Write-Host '' }; "
           . "Write-Host '[1. Text Line Match]' -ForegroundColor Cyan; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }; "
           . "Write-Host '`n[2. Hotkeys Found (Path Only)]' -ForegroundColor Yellow; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String -Pattern ('^\s*[~$^+#!<>]*' + $pattern + '\s*::') | Select-Object -ExpandProperty Path -Unique | ForEach-Object { HL $_ }; "
           . "Write-Host '`n[3. Modifier Match]' -ForegroundColor Magenta; "
           . "Get-ChildItem -Recurse -File | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }`""

Run(psCommand)
ExitApp()