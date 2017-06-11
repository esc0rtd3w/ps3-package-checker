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
set isRegion=0

set prefixURL=https://
set serverA=%prefixURL%a0.ww.np.dl.playstation.net/tpl/np/%titleID%/%titleID%-ver.xml
set serverB=%prefixURL%b0.ww.np.dl.playstation.net/tppkg/np/%titleID%/%titleID%-ver.xml
set userAgent=--user-agent="Mozilla/5.0 (PLAYSTATION 3; 4.81)"
set disableCertCheck=--no-check-certificate


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

pause

set titleID=BLES01807

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


pause


goto start









:end

exit
