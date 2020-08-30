@echo off
title Remove May Updates
echo This script will remove affected May 2019 updates.
echo Your machine should reboot back into Windows following this task
echo Attempting removal of May 2019 update
wusa /uninstall /kb:4499164 /norestart /quiet
shutdown.exe /r /f /t 0
exit