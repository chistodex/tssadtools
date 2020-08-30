@echo off

title Change Administrator Password

echo.
echo activating local administrator...
net user administrator /active:yes
echo.
echo setting local administrator account password...
net user administrator @cme2570
echo.
echo setting local admin account password
net user admin @cme2570