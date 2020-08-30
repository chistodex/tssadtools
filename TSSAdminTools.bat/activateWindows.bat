@echo off

title Activate Windows

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.1" goto WIN7
if "%version%" == "10.0" goto WIN10

:WIN7
set key=insert-win-7-key-here
goto ACTIVATE

:WIN10
rem education license
rem set key=insert-win-10-edu-key-here
rem pro license
set key=insert-win-10-pro-key-here

goto ACTIVATE

:ACTIVATE
slmgr.vbs /ipk %key%
slmgr.vbs /ato
