@echo off

title Activate Windows

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.1" goto WIN7
if "%version%" == "10.0" goto WIN10

:WIN7
set key=KJQHK-6BBRV-H3C29-KB2JD-YJCHJ
goto ACTIVATE

:WIN10
rem education license
rem set key=PNM9D-TG9P4-J7DWP-77V3X-66PJD
rem pro license
set key=CYNT8-RVCCH-XFR7H-7H2BG-HFR9M

goto ACTIVATE

:ACTIVATE
slmgr.vbs /ipk %key%
slmgr.vbs /ato