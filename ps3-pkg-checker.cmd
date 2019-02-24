@echo off


:reset
:: Change terminal size
mode con lines=46


set scriptVersion=0.4
set titleText=PS3 Package Checker v%scriptVersion%             esc0rtd3w 2017  

title %titleText%


color 0e

set colorGlobal=0e

set waitTime=3
set wait=ping -n %waitTime% 127.0.0.1

set root=%cd%
set binPath=%root%\bin
set dumpPath=%root%\dump

set updateListComplete="%root%\dump\updateListComplete.txt"
set updateListActive="%root%\dump\updateListActive.txt"
set updateListFail="%root%\dump\updateListFail.txt"

set cocolor="%binPath%\cocolor.exe"
set wget="%binPath%\wget.exe"
set wgetQuiet="%binPath%\wget.exe" -q
set xml="%binPath%\xml.exe"

set titleID=XXXX00000
set titleIDRegionCode=XXXX
set titleIDRegionDisc=BXXX
set titleIDRegionPSN=NPXX
set titleIDNumber=00000
set titleIDNumberStart=0
set titleIDNumberMin=00000
set titleIDNumberMax=99999
set minMaxOverride=0
set isRegion=0
set padding=0

set isBlankXML=0

set prefixURL=https://
set serverA=%prefixURL%a0.ww.np.dl.playstation.net/tpl/np/%titleID%/%titleID%-ver.xml
set serverB=%prefixURL%b0.ww.np.dl.playstation.net/tppkg/np/%titleID%/%titleID%-ver.xml
set userAgent=--user-agent="Mozilla/5.0 (PLAYSTATION 3; 4.81)"
set disableCertCheck=--no-check-certificate

set isLoop=0
set prepareToLoop=0
set return=start


:start
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]
set titleChoice=99

cls
echo Choose an option and press ENTER:
echo.
echo.
%cocolor% 0a
echo 1) Check/Dump All Possible Title IDs**
echo.
%cocolor% 0b
echo 2) Check/Dump All PSN Title IDs**
echo 3) Check/Dump All Disc Title IDs**
echo.
%cocolor% 05
echo 4) Check/Dump All JAPAN Title IDs [BCJS]
echo 5) Check/Dump All JAPAN Title IDs [BLJM]
echo 6) Check/Dump All JAPAN Title IDs [NPJB]
echo 7) Check/Dump All JAPAN Title IDs [BLJS]
echo 8) Check/Dump All JAPAN Title IDs [NPJA]
echo.
%cocolor% 09
:: BCUS00236 -> BCUS99247
echo 9) Check/Dump All USA Title IDs [BCUS]
:: BLUS00759 -> BLUS83009
echo 10) Check/Dump All USA Title IDs [BLUS]
echo 11) Check/Dump All USA Title IDs [NPUB]
echo 12) Check/Dump All USA Title IDs [NPUA]
echo.
%cocolor% 06
echo 13) Check/Dump All EUROPE Title IDs [BCES]
:: BLES00012 -> BLES82001
echo 14) Check/Dump All EUROPE Title IDs [BLES]
:: NPEB00001 -> NPEB90464
echo 15) Check/Dump All EUROPE Title IDs [NPEB]
:: NPEA00002 -> NPEA90112
echo 16) Check/Dump All EUROPE Title IDs [NPEA]
echo.
%cocolor% 08
echo 17) Check/Dump All ASIA Title IDs [BCAS]
echo 18) Check/Dump All ASIA Title IDs [BLAS]
echo 19) Check/Dump All ASIA Title IDs [NPHB]
echo 20) Check/Dump All ASIA Title IDs [NPHA]
echo.
%cocolor% 07
echo 21) Check/Dump All HK Title IDs [BCKS]
echo 22) Check/Dump All HK Title IDs [BLKS]
echo 23) Check/Dump All HK Title IDs [NPKB]
echo 24) Check/Dump All HK Title IDs [NPKA]
echo.
%cocolor% 04
echo 25) Check/Dump All HK Title IDs [NPIA]
echo 26) Check/Dump All HK Title IDs [NPUO]
echo.
%cocolor% 0d
echo C) Enter Custom Title ID
echo.
%cocolor% 0e
echo S) Settings
echo.
%cocolor% 0e
echo X) Exit Menu
echo.

set /p titleChoice=


:skipMenu


if %titleChoice%==C set prepareToLoop=0&&goto custom
if %titleChoice%==c set prepareToLoop=0&&goto custom

if %titleChoice%==S goto msettings
if %titleChoice%==s goto msettings

if %titleChoice%==X goto end
if %titleChoice%==x goto end

if %titleChoice% gtr 26 goto start


if %titleChoice%==1 set prepareToLoop=1&&goto all

if %titleChoice%==2 set prepareToLoop=1&&goto psn
if %titleChoice%==3 set prepareToLoop=1&&goto disc

if %titleChoice%==4 set isRegion=JPN&&set titleIDRegionCode=BCJS&&set prepareToLoop=1&&goto region
if %titleChoice%==5 set isRegion=JPN&&set titleIDRegionCode=BLJM&&set prepareToLoop=1&&goto region
if %titleChoice%==6 set isRegion=JPN&&set titleIDRegionCode=NPJB&&set prepareToLoop=1&&goto region
if %titleChoice%==7 set isRegion=JPN&&set titleIDRegionCode=BLJS&&set prepareToLoop=1&&goto region
if %titleChoice%==8 set isRegion=JPN&&set titleIDRegionCode=NPJA&&set prepareToLoop=1&&goto region

if %titleChoice%==9 set isRegion=USA&&set titleIDRegionCode=BCUS&&set titleIDNumberMin=98081&&set titleIDNumberMax=99247&&set prepareToLoop=1&&goto region
if %titleChoice%==10 set isRegion=USA&&set titleIDRegionCode=BLUS&&set titleIDNumberMin=30001&&set titleIDNumberMax=31597&&set prepareToLoop=1&&goto region
::if %titleChoice%==10 set isRegion=USA&&set titleIDRegionCode=BLUS&&set titleIDNumberMin=41003&&set titleIDNumberMax=41045&&set prepareToLoop=1&&goto region
if %titleChoice%==11 set isRegion=USA&&set titleIDRegionCode=NPUB&&set prepareToLoop=1&&goto region
if %titleChoice%==12 set isRegion=USA&&set titleIDRegionCode=NPUA&&set prepareToLoop=1&&goto region

if %titleChoice%==13 set isRegion=EUR&&set titleIDRegionCode=BCES&&set prepareToLoop=1&&goto region
if %titleChoice%==14 set isRegion=EUR&&set titleIDRegionCode=BLES&&set titleIDNumberMin=00012&&set titleIDNumberMax=02245&&set prepareToLoop=1&&goto region
if %titleChoice%==15 set isRegion=EUR&&set titleIDRegionCode=NPEB&&goto region&&set titleIDNumberMin=00001&&set titleIDNumberMax=02404&&set prepareToLoop=1&&goto region
::if %titleChoice%==15 set isRegion=EUR&&set titleIDRegionCode=NPEB&&goto region&&set titleIDNumberMin=90003&&set titleIDNumberMax=90464&&set prepareToLoop=1&&goto region
if %titleChoice%==16 set isRegion=EUR&&set titleIDRegionCode=NPEA&&set titleIDNumberMin=00002&&set titleIDNumberMax=00514&&set prepareToLoop=1&&goto region
::if %titleChoice%==16 set isRegion=EUR&&set titleIDRegionCode=NPEA&&set titleIDNumberMin=90001&&set titleIDNumberMax=90112&&set prepareToLoop=1&&goto region

if %titleChoice%==17 set isRegion=ASIA&&set titleIDRegionCode=BCAS&&set prepareToLoop=1&&goto region
if %titleChoice%==18 set isRegion=ASIA&&set titleIDRegionCode=BLAS&&set prepareToLoop=1&&goto region
if %titleChoice%==19 set isRegion=ASIA&&set titleIDRegionCode=NPHB&&set prepareToLoop=1&&goto region
if %titleChoice%==20 set isRegion=ASIA&&set titleIDRegionCode=NPHA&&set prepareToLoop=1&&goto region

if %titleChoice%==21 set isRegion=HK&&set titleIDRegionCode=BCKS&&set prepareToLoop=1&&goto region
if %titleChoice%==22 set isRegion=HK&&set titleIDRegionCode=BLKS&&set prepareToLoop=1&&goto region
if %titleChoice%==23 set isRegion=HK&&set titleIDRegionCode=NPKB&&set prepareToLoop=1&&goto region
if %titleChoice%==24 set isRegion=HK&&set titleIDRegionCode=NPKA&&set prepareToLoop=1&&goto region

if %titleChoice%==25 set isRegion=INT&&set titleIDRegionCode=NPIA&&set prepareToLoop=1&&goto region
if %titleChoice%==26 set isRegion=INT&&set titleIDRegionCode=NPUO&&set prepareToLoop=1&&goto region


:: Safety Net
goto start


:msettings
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]
set settingsChoice=99

cls
echo Choose an option and press ENTER:
echo.
echo.
%cocolor% 0a
echo 1) Change Minimum Value
echo.
%cocolor% 0b
echo 2) Change Maximum Value
echo.
echo.
%cocolor% 0e
echo B) Go Back
echo.
echo X) Exit Menu
echo.

set /p settingsChoice=


if %settingsChoice%==B goto start
if %settingsChoice%==b goto start

if %settingsChoice%==X goto end
if %settingsChoice%==x goto end

if %settingsChoice%==1 goto valueMin
if %settingsChoice%==2 goto valueMax

if %settingsChoice% gtr 2 goto msettings

:: Safety Net
goto msettings



:valueMin
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Set Minimum Value and press ENTER:
echo.
echo.

set /p titleIDNumberMin=

if %titleIDNumberMin% gtr 99999 goto valueMin
set titleIDNumberMinCustom=%titleIDNumberMin%

goto msettings



:valueMax
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Set Maximum Value and press ENTER:
echo.
echo.

set /p titleIDNumberMax=

if %titleIDNumberMax% gtr 99999 goto valueMax
set titleIDNumberMaxCustom=%titleIDNumberMax%

goto msettings





:all
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Check All Possible Title IDs
echo.
echo.

pause

set titleID=BLES01807

set isLoop=0
set return=start

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:psn
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Check All PSN Title IDs
echo.
echo.

pause

set titleID=BLES01807

set isLoop=0
set return=start

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:disc
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Check All Disc Title IDs
echo.
echo.

pause

set titleID=BLES01807

set isLoop=0
set return=start

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer



:region
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Check All %isRegion% Title IDs
echo.
echo.

:: Region Start
if %isRegion%==JPN (
set dumpPath=%root%\dump\JPN\%titleIDRegionCode%
)

if %isRegion%==EUR (
set dumpPath=%root%\dump\EUR\%titleIDRegionCode%
)

if %isRegion%==USA (
set dumpPath=%root%\dump\USA\%titleIDRegionCode%
)

if %isRegion%==HK (
set dumpPath=%root%\dump\HK\%titleIDRegionCode%
)

if %isRegion%==ASIA (
set dumpPath=%root%\dump\ASIA\%titleIDRegionCode%
)

if %isRegion%==INT (
set dumpPath=%root%\dump\INT\%titleIDRegionCode%
)


:: Force TitleID Values (Debug Only)
set titleIDNumberMin=0
set titleIDNumberMax=99999

:: Set Starting Number as Minimum
set titleIDNumber=%titleIDNumberMin%
set titleIDNumberMax=%titleIDNumberMax%


if %prepareToLoop%==0 (
set isLoop=0
set return=setServer
)

if %prepareToLoop%==1 (
set isLoop=1
set return=doLoop
)

goto %return%



:doLoop
if %titleIDNumber%==%titleIDNumberMax% goto start
if %titleIDNumber%==%titleIDNumberMax% set isLoop=0

if %isLoop%==1 set /a titleIDNumber=%titleIDNumber%+1

::title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]
::echo %titleIDNumber%
::pause

setlocal ENABLEDELAYEDEXPANSION

for %%a in (%titleIDNumber%) do (
    for /f "tokens=1-5" %%F in ("%%a") do (
	   set /a num=%%F
       set zeros=
       if !num! gtr 10000 set zeros=none
       if !num! lss 10000 set zeros=0
       if !num! lss 1000 set zeros=00
       if !num! lss 100 set zeros=000
       if !num! lss 10 set zeros=0000
       set "padding=!zeros!"
       echo !padding!>"%temp%\padding.tmp"
    )
)

endlocal

set /p padding=<"%temp%\padding.tmp"

set titleID=%titleIDRegionCode%%padding%%titleIDNumber%
if %padding%==none set titleID=%titleIDRegionCode%%titleIDNumber%

::echo %titleID%
::echo.
::pause

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:custom
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
echo Enter Custom Title ID and press ENTER:
echo.
echo.
echo B) Go Back
echo.
echo X) Exit Menu
echo.

set /p titleIDChoice=


if %titleIDChoice%==B goto %return%
if %titleIDChoice%==b goto %return%

if %titleIDChoice%==X goto end
if %titleIDChoice%==x goto end

set titleID=%titleIDChoice%


if %prepareToLoop%==0 (
set isLoop=0
set return=custom
)

if %prepareToLoop%==1 (
set isLoop=1
set return=doLoop
)

set dumpPath=%root%\dump\CUSTOM

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer



:setServer
set serverA=%prefixURL%a0.ww.np.dl.playstation.net/tpl/np/%titleID%/%titleID%-ver.xml
set serverB=%prefixURL%b0.ww.np.dl.playstation.net/tppkg/np/%titleID%/%titleID%-ver.xml

goto dlPkg


:dlPkg
title %titleText% [Min/Max = %titleIDNumberMin%/%titleIDNumberMax%]

cls
%cocolor% 0b
echo Press CTRL+C To Interrupt The Current Operation
%cocolor% 0a
echo.
echo Current Title ID: %titleID%
%cocolor% 0d
echo Maximum Title ID: %titleIDRegionCode%%titleIDNumberMax%
::%cocolor% 0e
::echo.
::echo.
::echo Checking %titleID%.xml....
echo.
echo.

::%wget% %disableCertCheck% %userAgent% -O "%dumpPath%\%titleID%.xml" %serverA%
%wgetQuiet% %disableCertCheck% %userAgent% -O "%dumpPath%\%titleID%.xml" %serverA%


goto chkBlank


:chkBlank
for %%a in ("%dumpPath%\%titleID%.xml") do (
  if %%~za equ 0 (
	set isBlankXML=1
  ) else (
	set isBlankXML=0
  )
)

goto addList


:addList
if %isBlankXML%==0 (
%cocolor% 0a
echo.
echo Writing %titleID%.xml....
echo.
echo %titleID%>>%updateListComplete%
echo %titleID%>>%updateListActive%
)

if %isBlankXML%==1 (
%cocolor% 0c
echo.
echo %titleID%.xml Is Not A Valid Title ID....
echo.
echo %titleID%>>%updateListComplete%
echo %titleID%>>%updateListFail%
del /f /q "%dumpPath%\%titleID%.xml"
)


::if %titleIDNumber%==%titleIDNumberMax% set return=start&&set isLoop=0

if %isLoop%==0 goto start
if %isLoop%==1 goto %return%






:end

exit
