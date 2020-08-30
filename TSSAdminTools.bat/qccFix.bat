@echo off

title QCC Fix

::add qss user to local admin group
echo adding tsd\qcc1439 to local administrator group...
net localgroup administrators tsd\qcc1439 /add

::add requisitions printer
echo adding requisitions printer...
rundll32.exe printui.dll,PrintUIEntry /ga /z /n"\\print01\DO Requisitions HPM602"

::assign variables
set networkqcc=\\tsd-do-02\sdrive\Software Installs\!Site Folders\District Office\.Dept - Fiscal\QCC\2020\QSSControlCenter
set localqcc=c:\QSS\QSSControlCenter\
set qccshortcut=C:\Users\Public\Desktop\QSS Control Center.lnk

::remove old files
echo deleting files from local qcc directory...
rmdir /S /Q %localqcc%

::copy qcc files
echo copying files from network to local directory...
pushd %networkqcc%
xcopy "%CD%" "%localqcc%" /y /c /k /s /q
popd


::run qcc
::start "%qccshortcut%"

echo completed!