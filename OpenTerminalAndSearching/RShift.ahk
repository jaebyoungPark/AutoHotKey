#Requires AutoHotkey v2.0
SplitPath(A_ScriptName, , , , &nameNoExt)
TargetDir := "E:\GitProject\AutoHotKey\AutoHotKey"

psCommand := "powershell.exe -NoExit -Command `"cd '" TargetDir "'; "
           . "$kw = '" nameNoExt "'; "
           . "function HL { param($line) $parts = $line -split [regex]::Escape($kw); for ($i=0; $i -lt $parts.Count; $i++) { Write-Host $parts[$i] -NoNewline; if ($i -lt $parts.Count-1) { Write-Host $kw -NoNewline -ForegroundColor Black -BackgroundColor Yellow } } Write-Host '' }; "
           . "Write-Host '[1. FileName Match]' -ForegroundColor Cyan; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String $kw | ForEach-Object { HL $_.ToString() }; "
           . "Write-Host '`n[2. Hotkeys Found (Path Only)]' -ForegroundColor Yellow; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Select-String ('^\s*[~$^+#!<>]*' + $kw + '\s*::') | Select-Object -ExpandProperty Path -Unique | ForEach-Object { HL $_ }; "
           . "Write-Host '`n[3. Modifier Match]' -ForegroundColor Magenta; "
           . "Get-ChildItem -Recurse -File | Select-String ('\^' + $kw) | ForEach-Object { HL $_.ToString() }`""

Run(psCommand)
ExitApp()