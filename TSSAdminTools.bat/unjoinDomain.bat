@echo off

title Unjoin Domain

start /B /W wmic.exe /interactive:off ComputerSystem Where "Name='%computername%'" Call UnJoinDomainOrWorkgroup FUnjoinOptions=0
start /B /W wmic.exe /interactive:off ComputerSystem Where "Name='%computername%'" Call JoinDomainOrWorkgroup name="1"