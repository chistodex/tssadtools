@echo off

title Run Ninite

if '%1'=='/i' goto INSTALL
if '%1'=='/u' goto UPDATE
if '%1'=='/?' goto HELP

set ninite=NinitePro20180319.exe
set apps=niniteapps.txt
set report=ninitereport.txt

echo ## NINITE APP LIST ##
type nul > %apps%
%ninite% /list /silent %apps%
type %apps%

:BOF
set num=""
set /p num=(u)pdate, (i)nstall, or (c)ancel? 

if %num%==u goto UPDATE
if %num%==i goto INSTALL
if %num%==c goto EOF
goto BOF

:UPDATE
echo updating ninite...
call NinitePro20180319.exe /updateonly /silent %report%
goto EOF

:INSTALL
echo installing ninite...
call NinitePro20180319.exe /silent %report%
goto EOF

:HELP
echo.
echo  ##############
echo  # Run Ninite #
echo  ##############
echo.
echo  Date: 2018.03.20
echo  Author: Chris Mitchell
echo.
echo  Runs Ninite in silent mode. You need the file %ninite% in the same directory as runNinite.
echo.
echo  ## App List ##
type nul > %apps%
type %apps%
echo.
echo  /u	Runs only the updates. No new apps will be installed.
echo  /i	Runs the installers. Updates when appropriate and installs new apps.
pause
goto EOF

:EOF
echo Completed. See ninitereport.txt for details.