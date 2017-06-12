@echo off


:reset

set scriptVersion=0.1

title PS3 Package Checker v%scriptVersion%                      esc0rtd3w 2017


color 0e

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
set xml="%binPath%\xml.exe"

set titleID=XXXX00000
set titleIDRegionDisc=BXXX
set titleIDRegionPSN=NPXX
set titleIDNumber=00000
set titleIDNumberStart=0
set isRegion=0
set padding=0

set prefixURL=https://
set serverA=%prefixURL%a0.ww.np.dl.playstation.net/tpl/np/%titleID%/%titleID%-ver.xml
set serverB=%prefixURL%b0.ww.np.dl.playstation.net/tppkg/np/%titleID%/%titleID%-ver.xml
set userAgent=--user-agent="Mozilla/5.0 (PLAYSTATION 3; 4.81)"
set disableCertCheck=--no-check-certificate

set isLoop=0
set return=start


:start
set titleChoice=99

cls
echo Choose an option and press ENTER:
echo.
echo.
echo 1) Check All Possible Title IDs
echo.
echo 2) Check All PSN Title IDs
echo.
echo 3) Check All Disc Title IDs
echo.
echo 4) Check All JAPAN Title IDs
echo 5) Check All USA Title IDs
echo 6) Check All EUROPE Title IDs
echo 7) Check All ASIA Title IDs
echo 8) Check All HK Title IDs
echo.
echo 9) Enter Custom Title ID
echo.
echo.
echo X) Exit Menu
echo.
echo.

set /p titleChoice=

if %titleChoice%==X goto end
if %titleChoice%==x goto end

if %titleChoice% gtr 9 goto start


if %titleChoice%==1 goto all
if %titleChoice%==2 goto psn
if %titleChoice%==3 goto disc
if %titleChoice%==4 set isRegion=JPN&&goto region
if %titleChoice%==5 set isRegion=USA&&goto region
if %titleChoice%==6 set isRegion=EUR&&goto region
if %titleChoice%==7 set isRegion=ASIA&&goto region
if %titleChoice%==8 set isRegion=HK&&goto region
if %titleChoice%==9 goto custom




:all
cls
echo Check All Possible Title IDs
echo.
echo.

pause

set titleID=BLES01807

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:psn
cls
echo Check All PSN Title IDs
echo.
echo.

pause

set titleID=BLES01807

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:disc
cls
echo Check All Disc Title IDs
echo.
echo.

pause

set titleID=BLES01807

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer



:region
cls
echo Check All %isRegion% Title IDs
echo.
echo.

:: Region Start
if %isRegion%==JPN set dumpPath=%root%\dump\JPN
if %isRegion%==JPN set titleIDNumber=55000
::if %isRegion%==JPN set titleIDRegionDisc=BCJS
if %isRegion%==JPN set titleIDRegionDisc=BLJM
if %isRegion%==JPN set titleIDRegionPSN=NPJB
::if %isRegion%==JPN set titleIDRegionPSN=NPJA

if %isRegion%==EUR set dumpPath=%root%\dump\EUR
if %isRegion%==EUR set titleIDNumber=00000
::if %isRegion%==EUR set titleIDRegionDisc=BCES
if %isRegion%==EUR set titleIDRegionDisc=BLES
if %isRegion%==EUR set titleIDRegionPSN=NPEB
::if %isRegion%==EUR set titleIDRegionPSN=NPEA

if %isRegion%==USA set dumpPath=%root%\dump\USA
if %isRegion%==USA set titleIDNumber=30000
::if %isRegion%==USA set titleIDRegionDisc=BCUS
if %isRegion%==USA set titleIDRegionDisc=BLUS
if %isRegion%==USA set titleIDRegionPSN=NPUB
::if %isRegion%==USA set titleIDRegionPSN=NPUA

if %isRegion%==HK set dumpPath=%root%\dump\HK
if %isRegion%==HK set titleIDNumber=20000
::if %isRegion%==HK set titleIDRegionDisc=BCKS
if %isRegion%==HK set titleIDRegionDisc=BLKS
if %isRegion%==HK set titleIDRegionPSN=NPKB
::if %isRegion%==HK set titleIDRegionPSN=NPKA

if %isRegion%==ASIA set dumpPath=%root%\dump\ASIA
if %isRegion%==ASIA set titleIDNumber=50000
::if %isRegion%==ASIA set titleIDRegionDisc=BCAS
if %isRegion%==ASIA set titleIDRegionDisc=BLAS
if %isRegion%==ASIA set titleIDRegionPSN=NPHB
::if %isRegion%==ASIA set titleIDRegionPSN=NPHA

set isLoop=1
set return=regionL

:regionL
if %isLoop%==1 set /a titleIDNumber=%titleIDNumber%+1

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

set titleID=%titleIDRegionDisc%%padding%%titleIDNumber%
if %padding%==none set titleID=%titleIDRegionDisc%%titleIDNumber%

echo %titleID%
echo.
::pause

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer


:custom
cls
echo Enter Custom Title ID and press ENTER:
echo.
echo.

set /p titleID=

if not exist "%dumpPath%" mkdir "%dumpPath%"

goto setServer



:setServer
set serverA=%prefixURL%a0.ww.np.dl.playstation.net/tpl/np/%titleID%/%titleID%-ver.xml
set serverB=%prefixURL%b0.ww.np.dl.playstation.net/tppkg/np/%titleID%/%titleID%-ver.xml

goto dlPkg


:dlPkg
%wget% %disableCertCheck% %userAgent% -O "%dumpPath%\%titleID%.xml" %serverA%

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
echo %titleID%>>%updateListComplete%
echo %titleID%>>%updateListActive%
)

if %isBlankXML%==1 (
echo %titleID%>>%updateListComplete%
echo %titleID%>>%updateListFail%
del /f /q "%dumpPath%\%titleID%.xml"
)


::pause


if %isLoop%==0 goto start
if %isLoop%==1 goto %return%









:end

exit
