```ahk
#Requires AutoHotkey v2.0

; 파일명 : OpenTerminalAndSearching.ahk
;
; ============================================================
; 검색 키워드 설정
; ============================================================

; 🔍 찾고 싶은 키워드
kw := "#e"

; PowerShell 문자열 내에서 홑따옴표(')가 충돌하지 않도록
; 두 개('')로 치환하여 이스케이프 처리
safeKw := StrReplace(kw, "'", "''")

; ============================================================
; 검색 범위 설정
; ============================================================

; 현재 스크립트가 위치한 폴더의 상위 폴더를 검색 루트로 지정
;
; 예시:
; 현재 파일 위치:
; E:\Programs\MyGits\AutoHotKey\Auto_HotKey\OpenTerminalAndSearching
;
; 검색 시작 위치:
; E:\Programs\MyGits\AutoHotKey\Auto_HotKey
;
; 따라서 검색 루트 폴더 자체와 그 아래에 있는 모든 하위 폴더가
; 검색 대상이 됨.
;
; 예를 들어 Blender, Unreal 등의 하위 폴더도 모두 탐색함.

TargetDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")


; ============================================================
; PowerShell 검색 명령 구성
; ============================================================

psCommand := "powershell.exe -NoExit -Command `"cd '" TargetDir "'; "
           . "$kw = '" safeKw "'; "
           . "$pattern = [regex]::Escape($kw); " 


           ; ------------------------------------------------
           ; 하이라이트(HL) 함수
           ; ------------------------------------------------
           ; 검색 결과에서 키워드 부분을 노란색 배경으로 강조 표시
           ;
           ; 검색된 문자열을 키워드 기준으로 분리한 다음,
           ; 키워드 부분만 검은색 글자 + 노란색 배경으로 출력함.

           . "function HL { param($line) $parts = $line -split $pattern; for ($i=0; $i -lt $parts.Count; $i++) { Write-Host $parts[$i] -NoNewline; if ($i -lt $parts.Count-1) { Write-Host '" safeKw "' -NoNewline -ForegroundColor Black -BackgroundColor Yellow } } Write-Host '' }; "


           ; =================================================
           ; [1. Text Line Match]
           ; =================================================
           ; 검색 대상:
           ; 검색 루트 폴더와 모든 하위 폴더에 있는 .ahk 파일
           ;
           ; 탐색 방식:
           ; Get-ChildItem -Recurse -Filter *.ahk
           ;   → 하위 폴더까지 재귀적으로 탐색하며 .ahk 파일 수집
           ;
           ; Where-Object:
           ;   → 경로에 .git 폴더가 포함된 파일 제외
           ;
           ; Select-String:
           ;   → 각 AHK 파일의 소스코드 내용에서 키워드 검색
           ;
           ; 출력:
           ;   → 키워드가 포함된 코드 줄 전체 출력
           ;   → 검색 키워드는 노란색으로 강조 표시

           . "Write-Host '[1. Text Line Match]' -ForegroundColor Cyan; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Where-Object { $_.FullName -notlike '*\.git*' } | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }; "


           ; =================================================
           ; [2. Hotkeys Found (Path Only)]
           ; =================================================
           ; 검색 대상:
           ; 검색 루트 폴더와 모든 하위 폴더에 있는 .ahk 파일
           ;
           ; 탐색 방식:
           ; Get-ChildItem -Recurse -Filter *.ahk
           ;   → 모든 하위 폴더의 AHK 파일 탐색
           ;
           ; Select-String 정규식:
           ;   → AHK 핫키 선언 형식에 맞는 줄만 검색
           ;
           ; 정규식:
           ; ^\s*[~$^+#!<>]* + 키워드 + \s*::
           ;
           ; 예시:
           ; #e::
           ; ^#e::
           ; ~$#e::
           ;
           ; Select-Object -ExpandProperty Path -Unique:
           ;   → 핫키가 발견된 파일의 경로만 추출
           ;   → 동일한 파일 경로는 중복 출력하지 않음
           ;
           ; 출력:
           ;   → 해당 핫키가 발견된 AHK 파일 경로만 출력
           ;   → 파일 경로 안의 검색 키워드는 노란색으로 강조

           . "Write-Host '`n[2. Hotkeys Found (Path Only)]' -ForegroundColor Yellow; "
           . "Get-ChildItem -Recurse -Filter *.ahk | Where-Object { $_.FullName -notlike '*\.git*' } | Select-String -Pattern ('^\s*[~$^+#!<>]*' + $pattern + '\s*::') | Select-Object -ExpandProperty Path -Unique | ForEach-Object { HL $_ }; "


           ; =================================================
           ; [3. Modifier Match (Text Files Only)]
           ; =================================================
           ; 검색 대상:
           ; 검색 루트 폴더와 모든 하위 폴더에 있는 일반 파일
           ;
           ; 탐색 방식:
           ; Get-ChildItem -Recurse -File
           ;   → 모든 하위 폴더의 파일을 확장자 제한 없이 탐색
           ;
           ; Where-Object:
           ;   → .git 경로에 포함된 파일 제외
           ;   → 아래에 지정된 바이너리 및 미디어 확장자 제외
           ;
           ; 제외 확장자:
           ; exe, dll, lnk, bin, dat, db,
           ; png, jpg, gif, jpeg, bmp,
           ; ico, ani, cur,
           ; ttf, woff,
           ; zip, rar, 7z
           ;
           ; Select-String:
           ;   → 필터를 통과한 파일의 내용에서 키워드 검색
           ;
           ; 출력:
           ;   → 키워드가 포함된 파일의 해당 줄 출력
           ;   → 검색 키워드는 노란색으로 강조 표시
           ;
           ; 주의:
           ;   → 위 제외 확장자 외에는 모두 검색 대상이므로
           ;     txt, ini, py, json, ahk 등도 검색됨.

           . "Write-Host '`n[3. Modifier Match (Text Files Only)]' -ForegroundColor Magenta; "
           . "Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notlike '*\.git*' -and $_.Extension -notmatch '^\.(exe|dll|lnk|bin|dat|db|png|jpg|gif|jpeg|bmp|ico|ani|cur|ttf|woff|zip|rar|7z)$' } | Select-String -Pattern $pattern | ForEach-Object { HL $_.ToString() }`""


; ============================================================
; PowerShell 실행
; ============================================================

; PowerShell 창을 열어 검색 결과를 출력함.
; -NoExit 옵션으로 검색이 끝난 후에도 터미널 창을 유지함.

Run(psCommand)

ExitApp()
```