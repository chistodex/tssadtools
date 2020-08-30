@echo off
title Remove April Updates
echo This script will remove affected April 2019 Windows updates as per Sophos KBA https://sophos.com/kb/133945
echo Your machine should reboot back into Windows following this task
echo Attempting removal of April 2019 Windows 7/Server 2008 R2 Updates
wusa /uninstall /kb:4493448 /norestart /quiet
wusa /uninstall /kb:4493472 /norestart /quiet
shutdown.exe /r /f /t 0
exit