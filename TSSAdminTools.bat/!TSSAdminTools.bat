@echo off

title TSSAdmin Tools

pushd %root%
if %errorlevel% neq 0 goto:EOF

set version=1.66.2020.05.01

if '%1'=='/?' goto HELP
if '%1'=='/a' goto RUNALLQUICK
goto START

:HELP
echo.
echo  #####################
echo  #   TSSAdmin Tools  #
echo  #####################
echo.
echo  Version: %version%
echo  Date: 2020.05.01
echo  Author: Chris Mitchell
echo.
echo  This file runs scripts that allows you to
echo   -change the admin password
echo   -activate the local Administrator account and set the password
echo   -change the name of the My Computer icon and add it to the desktop
echo   -disable sleep mode
echo   -disable Sync Center
echo   -enable remote desktop
echo   -clean up user profiles
echo   -unjoin the computer from the domain
echo   -create the Local programs folder with correct user permissions
echo   -allow powershell scripts
echo   -fix qcc 2020.05.01
echo.
echo.
echo  /a    -Run all
pause
goto EOF

:START
color F0
goto CHECKADMIN

:MENU
cd /D %drive%
cls
echo.
echo  #############################
echo  #    TSSAdmin Tools  v%version%   #
echo  #############################
echo.
echo  Option:	Description:
echo  1.........Activate Administrator account and update password*
echo  2.........Change My Computer name and add it to desktop*
echo  3.........Disable Sleep Mode*
echo  4.........Disable Sync Center (requires restart)*
echo  5.........Enable Remote Desktop*
echo  6.........Clean up user profiles*
echo  7.........Unjoin domain
echo  8.........Create Local programs folder*
echo.
echo  9.........QCC Fix
echo  10........Activate Office
echo  11........Activate Windows
echo.
echo  12........Allow Powershell Scripts
echo  15........Clear Print Queue
echo.
echo  17........Ping Servers
echo  18........GP Update Force (requires restart)
echo.
echo  all.......Run (A)ll*
echo  res.......Restart Computer
echo  exit......(Q)uit program
echo.
set num=""
set /p num=Choose an option: 

if %num%==1 goto 1
if %num%==2 goto 2
if %num%==3 goto 3
if %num%==4 goto 4
if %num%==5 goto 5
if %num%==6 goto 6
if %num%==7 goto 7
if %num%==8 goto 8
if %num%==9 goto 9
if %num%==10 goto 10
if %num%==11 goto 11
if %num%==12 goto 12
if %num%==14 goto 14
if %num%==15 goto 15
if %num%==16 goto 16
if %num%==17 goto 17
if %num%==18 goto 18
if %num%==all goto RUNALL
if %num%==ALL goto RUNALL
if %num%==A goto RUNALL
if %num%==res goto RESTART
if %num%==RES goto RESTART
if %num%==exit goto EXIT
if %num%==EXIT goto EXIT
if %num%==Q goto EXIT
echo Ugh, why you so difficult?!
pause
goto MENU


:1
call changeAdministratorPassword
pause
goto MENU

:2
call changeMyComputerName
pause
goto MENU

:3
call disableSleep
pause
goto MENU

:4
call disableSyncCenter
pause
goto MENU

:5
call enableRemoteDesktop
pause
goto MENU

:6
call userProfileCleaning
pause
goto MENU

:7
call unjoinDomain
pause
goto MENU

:8
call makeLocalFolder
pause
goto MENU

:9
call qccFix
pause
goto MENU

:10
call activateOffice
pause
goto MENU

:11
call activateWindows
pause
goto MENU

:12
call allowPowershellScripts
pause
goto MENU

:15
call clearPrintQueue
pause
goto MENU

:17
call pingServers
pause
goto MENU

:18
call gpUpdateForce
pause
goto MENU

:RESTART
call restartComputerNow
goto EOF

:RUNALL
start cmd /C changeAdministratorPassword.bat
start cmd /C changeMyComputerName.bat
start cmd /C disableSleep.bat
start cmd /C disableSyncCenter.bat
start cmd /C enableRemoteDesktop.bat
start cmd /C makeLocalFolder.bat
start cmd /C userProfileCleaning.bat
pause
goto MENU

:RUNALLQUICK
echo.
echo #############################
echo #    TSSAdmin Tools  v%version%   #
echo #############################
echo.
echo changing Administrator/Admin password...
start cmd /C changeAdministratorPassword.bat
echo changing My Computer and adding to desktop...
start cmd /C changeMyComputerName.bat
echo disabling sleep mode...
start cmd /C disableSleep.bat
echo enabling Remote Desktop...
start cmd /C enableRemoteDesktop.bat
echo creating Local folder...
call makeLocalFolder.bat
echo starting profile cleaning...
call userProfileCleaning
set num=""
set /p num=All scripts ran. Restart(y)?: 
if %num%==y goto RESTART
if %num%==Y goto RESTART
goto EXIT

:CHECKADMIN
net session >nul 2>&1
if %ERRORLEVEL% == 0 goto MENU
echo ERROR - Admin privilages required. Right-click and choose Run as Administrator.
pause
goto EOF

:EXIT
echo.
popd
echo Goodbye...
goto EOF

:EOF
color