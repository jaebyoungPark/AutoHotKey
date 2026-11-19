#Requires AutoHotkey v2.0
#SingleInstance Force

TargetDir := "E:\Programs\MyGits\AutoHotKey\Auto_HotKey"
kw := "gom64"
safeKw := StrReplace(kw, "'", "''")

psCommand := "powershell.exe -NoExit -Command `""
    . "$TargetDir = '" TargetDir "'; "
    . "if (-not (Test-Path -LiteralPath $TargetDir)) { "
    . "Write-Host '검색 폴더가 존재하지 않습니다.' -ForegroundColor Red; exit "
    . "}; "
    . "Set-Location -LiteralPath $TargetDir; "
    . "$kw = '" safeKw "'; "
    . "$pattern = [regex]::Escape($kw); "
    . "$results = Get-ChildItem -Path $TargetDir -Recurse -Filter *.ahk -File | "
    . "Where-Object { "
    . "$_.FullName -notmatch '[\\/]\.git[\\/]' -and "
    . "$_.Name -ne 'FindKeyword.ahk' "
    . "} | "
    . "ForEach-Object { "
    . "$file = $_; "
    . "$foundLines = Select-String -LiteralPath $file.FullName -Pattern $pattern | "
    . "Where-Object { $_.Line -notmatch '^\s*[^;].*?::' }; "
    . "if ($foundLines) { $file.FullName } "
    . "} | Sort-Object -Unique; "
    . "Write-Host ''; "
    . "Write-Host '[본문에서 키워드가 발견된 AHK 파일]' -ForegroundColor Cyan; "
    . "if ($results) { "
    . "$results | ForEach-Object { Write-Host $_ -ForegroundColor Yellow } "
    . "} else { "
    . "Write-Host '검색 결과 없음' -ForegroundColor Red "
    . "}`""

Run(psCommand)
ExitApp()