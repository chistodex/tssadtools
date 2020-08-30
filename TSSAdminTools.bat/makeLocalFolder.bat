@echo off

title Make Local Folder

if not exist C:\local mkdir c:\Local

cd /D C:\users\public\desktop
mklink /d Local C:\Local

if exist c:\local icacls "C:\local" /grant Everyone:(OI)(CI)F

cd /D %~dp0