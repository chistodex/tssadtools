@echo off

title Allow Powershell Scripts

>nul powershell.exe set-executionpolicy unrestricted -command set-executionpolicy remotesigned

powershell.exe -command get-executionpolicy -list
