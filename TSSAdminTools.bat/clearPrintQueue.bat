@echo off

title Clear Print Queue

net stop spooler

echo Clearing print queue...
del /f /q "C:\Windows\System32\spool\PRINTERS\"

net start spooler