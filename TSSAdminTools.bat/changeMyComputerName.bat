@echo off

title Change My Computer Name
:: Last Modified: 2018.06.06
:: Author: Chris Mitchell

:: changes My Computer to the Computer's Name
>nul reg add HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D} /v LocalizedString /t REG_EXPAND_SZ /d %%ComputerName%% /f

if %errorlevel% GTR 0 (
	echo.
	echo ERROR: cannot change My Computer icon name.
	echo Please check your permissions, then try again.
	echo.
	reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit /v LastKey /t REG_SZ /d HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D} /f > nul
	start regedit
) else (
	:: forces My Computer to show on the desktop of all new users
	reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 00000000 /f > nul	
	echo Success!
)