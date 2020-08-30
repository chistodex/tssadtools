@echo off

title Ping Servers

setlocal enabledelayedexpansion

set SERVERLIST[0]=de-admin
set SERVERLIST[1]=tsd-do
set SERVERLIST[2]=tsd-do-02
set SERVERLIST[3]=phs-admin
set SERVERLIST[4]=phs-campus
set SERVERLIST[5]=tjhs-admin
set SERVERLIST[6]=tjhs-campus
set SERVERLIST[7]=tj-rd180
set SERVERLIST[8]=cw-admin
set SERVERLIST[9]=md-admin
set SERVERLIST[10]=wl-msm
set SERVERLIST[11]=wl-vpa
set SERVERLIST[12]=br-admin
set SERVERLIST[13]=cr-admin
set SERVERLIST[14]=du-admin
set SERVERLIST[15]=du-campus
set SERVERLIST[16]=jl-admin
set SERVERLIST[17]=ths-admin
set SERVERLIST[18]=ths-campus
set SERVERLIST[19]=os-admin
set SERVERLIST[20]=cu-admin
set SERVERLIST[21]=wk-admin
set SERVERLIST[22]=exchange.turlock.k12.ca.us
set SERVERLIST[23]=aeries.turlock.k12.ca.us
set SERVERLIST[24]=tsd-fs01
set SERVERLIST[25]=tsd-dc01
set SERVERLIST[26]=tsd-dc02
set SERVERLIST[27]=tsd-avs-02
set SERVERLIST[28]=8.8.8.8
set SERVERLIST[29]=8.8.4.4

set FOGLIST[0][0]=doFog
set FOGLIST[0][1]=10.59.10.12
set FOGLIST[1][0]=thFog
set FOGLIST[1][1]=10.59.112.99
set FOGLIST[2][0]=phFog
set FOGLIST[2][1]=10.59.71.99

set ERROR=fail



for /l %%n in (0,1,29) do (
	ping !SERVERLIST[%%n]! -n 1 | find "TTL" > nul
	
	if errorlevel 1 (
		echo !SERVERLIST[%%n]!: !error!
	)
	if not errorlevel 1 (
		echo !SERVERLIST[%%n]!: success
	)
)

echo.
echo FOG Servers
echo.

for /l %%x in (0,1,2) do (
	ping !FOGLIST[%%x][1]! -n 1 | find "TTL" > nul

	if errorlevel 1 (
		echo !FOGLIST[%%x][0]!: !error!
	)
	if not errorlevel 1 (
		echo !FOGLIST[%%x][0]!: success
	)
)

GOTO EOF

:EOF
exit /b