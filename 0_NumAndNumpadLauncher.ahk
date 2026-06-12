#Requires AutoHotkey v2.0







; ==================================================



; 전역 설정



; ==================================================







; 스크립트 전역에서 정규표현식(|) 매칭 사용



SetTitleMatchMode("RegEx")











; ==================================================



; [함수 1]



; 창 활성화 / 순환 / 최소화



; ==================================================



ActivateOrCycleEx(searchTitle, runCommand := "", cycleTabIfSingle := true)



{



static WinIndexes := Map()







if !WinIndexes.Has(searchTitle)



WinIndexes[searchTitle] := 1







windows := WinGetList(searchTitle)



count := windows.Length







; --------------------------------------------------



; 창이 없으면 실행



; --------------------------------------------------



if (count = 0)



{



if (runCommand != "")



{



Run(runCommand)







; 최대 2초 대기



if WinWait(searchTitle, , 2)



{



; 최종 실제 HWND 다시 획득



hwnd := WinExist(searchTitle)







if hwnd



{



; 현재 마우스 모니터 좌표



coords := GetMouseMonitorCoords()







; 창 이동



try WinMove(



coords.X,



coords.Y,



,



,



"ahk_id " hwnd



)







; 최대화



try WinMaximize("ahk_id " hwnd)



}



}



}







return



}







if (WinIndexes[searchTitle] > count)



WinIndexes[searchTitle] := 1







currentIndex := WinIndexes[searchTitle]



activeHwnd := WinActive("A")







; ==================================================



; 현재 활성 창이 이미 해당 창인 경우



; ==================================================



if (activeHwnd = windows[currentIndex])



{



if (cycleTabIfSingle)



{



; 여러 창이면 다음 창



if (count > 1)



{



currentIndex := (currentIndex >= count)



? 1



: currentIndex + 1



}



else



{



; 현재 탭 제목



currentTitle := WinGetTitle("A")







; 다음 탭



Send "^{Tab}"







; 탭 변경 대기



Sleep 30







; 새 제목



newTitle := WinGetTitle("A")







; 탭 하나뿐이면 최소화



if (newTitle = currentTitle)



{



WinMinimize(windows[currentIndex])



return



}







; 새 탭이 조건 불일치면 원복 후 최소화



if !WinActive(searchTitle)



{



Send "^+{Tab}"



Sleep 20







WinMinimize(windows[currentIndex])



return



}







; 정상 이동



return



}



}



else



{



; 순환 비활성화 시 최소화



WinMinimize(windows[currentIndex])



return



}



}







; ==================================================

; 최소화 상태면 복구 후 활성화

; ==================================================

try

{

if (WinGetMinMax(windows[currentIndex]) = -1)

WinRestore(windows[currentIndex])



WinActivate(windows[currentIndex])



; 💡 유튜브 검은 화면 방지 (크롬 창 강제 새로고침 효과)

if WinActive("ahk_exe chrome.exe")

{

Sleep 50

WinGetPos(&X, &Y, &W, &H, windows[currentIndex])

WinMove(X, Y, W, H, windows[currentIndex])

}



WinIndexes[searchTitle] := currentIndex

}

}











; ==================================================



; [함수 2]



; 사이트 열기



;



; 짧게 : 전환



; 길게 : 새 탭



; ==================================================



OpenSite(keyName, searchTitle, url)



{



; 0.27초 기준



if KeyWait(keyName, "T0.27")



{



ActivateOrCycleEx(



searchTitle . " ahk_exe chrome.exe",



'chrome.exe --new-window "' . url . '"',



true



)



}



else



{



; 길게 누름 = 새 탭



if WinActive("ahk_exe chrome.exe")



{



Send "^t"



Sleep 150







SendText url



Send "{Enter}"



}



else



{



Run 'chrome.exe "' . url . '"'



}







KeyWait(keyName)



}



}











; ==================================================



; [함수 3]



; 현재 마우스 위치 모니터 좌표 구하기



; ==================================================



GetMouseMonitorCoords()



{



MouseGetPos(&mouseX, &mouseY)







monitorCount := MonitorGetCount()







Loop monitorCount



{



MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)







if (



mouseX >= Left



&& mouseX <= Right



&& mouseY >= Top



&& mouseY <= Bottom



) {



return {



X: Left,



Y: Top



}



}



}







; fallback



MonitorGet(1, &Left, &Top)







return {



X: Left,



Y: Top



}



}











; ==================================================



; [함수 4]



; 듀얼 모니터 마우스 순간이동



; ==================================================



MoveMouseToOtherMonitor()



{



monitorCount := MonitorGetCount()







; 듀얼 모니터 아니면 종료



if (monitorCount < 2)



return







CoordMode("Mouse", "Screen")







MouseGetPos &mouseX, &mouseY







currentMonitor := 0







; 현재 마우스 모니터 탐색



Loop monitorCount



{



MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)







if (



mouseX >= mLeft



&& mouseX < mRight



&& mouseY >= mTop



&& mouseY < mBottom



) {



currentMonitor := A_Index



break



}



}







if (currentMonitor = 0)



return







; 반대 모니터 결정



nextMonitor := (currentMonitor = 1)



? 2



: 1







; 대상 모니터 영역



MonitorGet(



nextMonitor,



&nLeft,



&nTop,



&nRight,



&nBottom



)







; 중앙 좌표



targetX := nLeft + (nRight - nLeft) / 2



targetY := nTop + (nBottom - nTop) / 2







; 순간이동 + 클릭



MouseMove(targetX, targetY, 0)



Click







; 피드백



ToolTip "🖱️ Monitor Switched"



SetTimer () => ToolTip(), -120



}











; ==================================================



; 개발 환경 판별



; ==================================================



IsDevEnvironment()



{



return (



WinActive("ahk_exe UE4Editor.exe")



|| WinActive("ahk_exe UnrealEditor.exe")



|| InStr(WinGetTitle("A"), "Unreal Editor")



|| WinActive("ahk_class UnrealWindow")







|| WinActive("ahk_exe devenv.exe")



)



}











; ==================================================



; 단축키 설정 영역



; ==================================================







; ==================================================



; 프로그램



; ==================================================







; Unreal Engine (프로젝트명 변경 및 모든 빌드 환경/파일이름 완벽 대응)



Numpad1:: ActivateOrCycleEx(



"Unreal Editor ahk_exe i)UnrealEditor",



,



false



)







; Visual Studio



Numpad2:: ActivateOrCycleEx(



"ahk_exe devenv.exe",



"devenv.exe",



false



)











; ==================================================



; 사진 / 메모장



; ==================================================



Numpad8::



{



; 짧게 : 사진 앱



if KeyWait("Numpad8", "T0.27")



{



ActivateOrCycleEx(



"ahk_exe Photos.exe",



"ms-photos:",



true



)



}



else



{



; 길게 : 메모장



ActivateOrCycleEx(



"ahk_class Notepad",



"notepad.exe",



true



)







KeyWait("Numpad8")



}



}











; ==================================================



; 웹사이트



; ==================================================







; Udemy



Numpad3:: OpenSite(



"Numpad3",



"Udemy",



"https://www.udemy.com/home/my-courses/learning/"



)







; CHZZK



Numpad4:: OpenSite(



"Numpad4",



"치지직|CHZZK",



"https://chzzk.naver.com/"



)







; SOOP



Numpad5:: OpenSite(



"Numpad5",



"SOOP|아프리카|Afreeca",



"https://www.sooplive.com/"



)







; YouTube



Numpad6:: OpenSite(



"Numpad6",



"YouTube",



"https://www.youtube.com/"



)







; NAVER



Numpad7:: OpenSite(



"Numpad7",



"GOOGLE|구글",



"https://www.google.com/"



)







; Claude



NumpadAdd:: OpenSite(



"NumpadAdd",



"Claude",



"https://claude.ai/"



)







; Gemini



NumpadSub:: OpenSite(



"NumpadSub",



"Gemini",



"https://gemini.google.com/"



)







; DCInside



NumLock:: OpenSite(



"NumLock",



"dcinside|디시인사이드|노산",



"https://gall.dcinside.com/mgallery/board/lists/?id=nobirth"



)











; ==================================================



; 새 창



; ==================================================



Numpad9::



{



; 짧게 : 크롬 새 창



if KeyWait("Numpad9", "T0.27")



{



Run 'chrome.exe --new-window'



}



else



{



; 길게 : 다음



OpenSite(



"Numpad9",



"Daum|다음",



"https://www.daum.net/"



)







KeyWait("Numpad9")



}



}











; ==================================================



; 최소화 / 전체화면



; ==================================================



Numpad0::



{



; 짧게 : 최소화



if KeyWait("Numpad0", "T0.27")



{



WinMinimize("A")



}



else



{



; 길게 : 전체화면



Send "{F11}"







KeyWait("Numpad0")



}



}











; ==================================================



; NumpadDiv (나누기 키) : ChatGPT일 때 위 방향키 2번



; ==================================================



NumpadDiv::



{



; ChatGPT 앱이면 위 방향키 2번



if WinActive("ahk_exe ChatGPT.exe")



{



Send "{Up 2}"



return



}







; 사진 앱이면 이전 사진



if WinActive("ahk_exe Photos.exe")



{



Send "{Left}"



return



}







; 개발 환경이면 즉시 모니터 이동



if IsDevEnvironment()



{



ToolTip "🟣 Dev Mode : Mouse Teleport (/)"



SetTimer () => ToolTip(), -300







MoveMouseToOtherMonitor()



return



}







; 일반 환경



if KeyWait("NumpadDiv", "T0.27")



{



; 짧게 : 이전 탭



Send "^+{Tab}"



}



else



{



; 길게 : 모니터 이동



MoveMouseToOtherMonitor()



KeyWait("NumpadDiv")



}



}







; ==================================================



; NumpadMult (곱하기 키) : ChatGPT일 때 아래 방향키 2번



; ==================================================



NumpadMult::



{



; ChatGPT 앱이면 아래 방향키 2번



if WinActive("ahk_exe ChatGPT.exe")



{



Send "{Down 2}"



return



}







; 사진 앱이면 다음 사진



if WinActive("ahk_exe Photos.exe")



{



Send "{Right}"



return



}







; 언리얼이면 모니터 이동



if WinActive("ahk_class UnrealWindow")



{



MoveMouseToOtherMonitor()



return



}







; 일반 환경



Send "^{Tab}"



}



; ==================================================



; 숫자 키 매핑



; ==================================================







; 아랫부분의 숫자 1 매핑도 함께 변경



1:: ActivateOrCycleEx(



"Unreal Editor ahk_exe i)UnrealEditor",



,



false



)







; 2 → Visual Studio



2:: ActivateOrCycleEx(



"ahk_exe devenv.exe",



"devenv.exe",



false



)







; 3 → Udemy



3:: OpenSite(



"3",



"Udemy",



"https://www.udemy.com/home/my-courses/learning/"



)







; 4 → CHZZK



4:: OpenSite(



"4",



"치지직|CHZZK",



"https://chzzk.naver.com/"



)







; 5 → SOOP



5:: OpenSite(



"5",



"SOOP|아프리카|Afreeca",



"https://www.sooplive.com/"



)







; 6 → YouTube



6:: OpenSite(



"6",



"YouTube",



"https://www.youtube.com/"



)







; 7 → NAVER



7:: OpenSite(



"7",



"GOOGLE|구글",



"https://www.google.com/"



)







; 8 → 사진 / 메모장



8::



{



; 짧게 : 사진 앱



if KeyWait("8", "T0.27")



{



ActivateOrCycleEx(



"ahk_exe Photos.exe",



"ms-photos:",



true



)



}



else



{



; 길게 : 메모장



ActivateOrCycleEx(



"ahk_class Notepad",



"notepad.exe",



true



)







KeyWait("8")



}



}







; 9 → DCInside



9:: OpenSite(



"9",



"dcinside|디시인사이드|노산",



"https://gall.dcinside.com/mgallery/board/lists/?id=nobirth"



)







; ==================================================



; F3 → Claude



; ==================================================



F3:: OpenSite(



"F3",



"Claude",



"https://claude.ai/"



)







; ==================================================



; F4 → Gemini



; ==================================================



F4:: OpenSite(



"F4",



"Gemini",



"https://gemini.google.com/"



)