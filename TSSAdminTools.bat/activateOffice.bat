@echo off

title Activate Office v2.0

setlocal enabledelayedexpansion

set PATHLIST[0]="C:\Program Files\Microsoft Office\Office14\OSPP.VBS"
set PATHLIST[1]="C:\Program Files (x86)\Microsoft Office\Office14\OSPP.VBS"
set PATHLIST[2]="C:\Program Files\Microsoft Office\Office15\OSPP.VBS"
set PATHLIST[3]="C:\Program Files (x86)\Microsoft Office\Office15\OSPP.VBS"
set PATHLIST[4]="C:\Program Files\Microsoft Office\Office16\OSPP.VBS"
set PATHLIST[5]="C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS"

set KEY2010=V3MCH-T24FK-T7K72-6JW3Q-CB74V
set KEY2013=QC4DG-JNRY3-6JC6R-246JR-367T7
set KEY2016=NY794-PKRKQ-RRJKR-F94KY-DPFHM

for /l %%n in (0,1,5) do (

	if exist !PATHLIST[%%n]! (

		if %%n leq 1 set KEY=%KEY2010%

		if %%n geq 2 set KEY=%KEY2013%
		
		if %%n geq 4 set KEY=%KEY2016%

		cscript !PATHLIST[%%n]! /inpkey:!KEY!
		cscript !PATHLIST[%%n]! /act
		cscript !PATHLIST[%%n]! /dstatus
	)
)