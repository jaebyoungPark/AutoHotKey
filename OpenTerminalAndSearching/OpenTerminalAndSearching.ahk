#Requires AutoHotkey v2.0
TargetDir := "E:\Programs\MyGits\AutoHotKey\AutoHotKey"

; 🔍 찾고 싶은 키워드
kw := "rbutton"

; 파워쉘 문자열 내에서 홑따옴표(')가 충돌하지 않도록 두 개('')로 치환하여 이스케이프 처리
safeKw := StrReplace(kw, "'", "''")

psCommand := "powershell.exe -NoExit -Command `"cd '" TargetDir "'; "
           . "$kw = '" safeKw "'; "
           . "$pattern = [regex]::Escape($kw); " 
           
           ; 하이라이트(HL) 함수 정의
           . "function HL { param($line) $parts = $line -split $pattern; for ($i=0; $i -lt $parts.Count; $i++) { Write-Host $parts[$i] -NoNewline; if ($i -lt $parts.Count-1) { Write-Host '" safeKw "' -NoNewline -ForegroundColor Black -BackgroundColor Yellow } } Write-Host '' }; "
           
           ; [1. Text Line Match] - 오직 .ahk 소스코드 내에서만 문장 검색
           . "Write-Host '[1. Text Line Match]' -ForegroundColor Cyan; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Where-Object { $_.FullName -notlike '*\.git*' } | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }; "
           
           ; [2. Hotkeys Found] - 오직 .ahk 소스코드 내에서만 핫키 매핑 정규식 스캔
           . "Write-Host '`n[2. Hotkeys Found (Path Only)]' -ForegroundColor Yellow; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Where-Object { $_.FullName -notlike '*\.git*' } | Select-String -Pattern ('^\s*[~$^+#!<>]*' + $pattern + '\s*::') | Select-Object -ExpandProperty Path -Unique | ForEach-Object { HL $_ }; "
           
           ; [3. Modifier Match] - ⭐ 필터에 ani, cur, ico 등 미디어/바이너리 확장자 대거 추가
           . "Write-Host '`n[3. Modifier Match (Text Files Only)]' -ForegroundColor Magenta; "
           . "Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notlike '*\.git*' -and $_.Extension -notmatch '^\.(exe|dll|lnk|bin|dat|db|png|jpg|gif|jpeg|bmp|ico|ani|cur|ttf|woff|zip|rar|7z)$' } | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }`""

Run(psCommand)
ExitApp()