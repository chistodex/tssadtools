@echo off

title Disable Sync Center

::this disables sync center - requires restart
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CSC /v Start /t REG_EXPAND_SZ /d 4 /f