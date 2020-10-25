<#
    Title: Printer Manager
    Author: Christopher Mitchell
    Version: 2020.06.03.1100
#>

function Add-SharedPrinter {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$PrinterShare,
        [string]$PrintServer = "print01",
        [string]$ComputerName = $ENV:COMPUTERNAME
    )

    #check for whole printer share or just partial printer share, match best case and prompt to contine
    if (Test-Connection -TargetName $ComputerName -Count 1 -Quiet -AND Test-Connection -TargetName $PrintServer -Count 1 -Quiet) {
        foreach ($computer in $ComputerName) {

            rundll32 printui.dll,PrintUIEntry /c\\$ComputerName /ga /z /n$PrinterShare

        }
    } else {
        Write-Host "Error: 134"
    }

    #error handling
    # check that client is reachable
    # check to make sure the printer exists on the print server
    # check to make sure the printer doesn't already exist on the client
}
function Remove-SharedPrinter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $PrinterShare,
        $ComputerName = $ENV:COMPUTERNAME
    )

    foreach ($printer in $PrinterShare) {
        rundll32 printui.dll,PrintUIEntry /c\\$ComputerName /ge /n$PrinterShare
    }

    #error handling
    # check that client is on
    # check to make sure the printer exists on the print server
    # check to make sure the printer doesn't already exist on the client
}

# this function will display all the shared printers on a machine
function Get-SharedPrinter {
    Param(
        [string]$ComputerName = $ENV:COMPUTERNAME
    )

    #rundll32 printui.dll,PrintUIEntry /c\\$ComputerName /ge
    $PrinterList = Get-Printer -ComputerName $ComputerName
    $PrinterList.Name
}


#Get-SharedPrinter

#get, from the registry, the per machine connections of printers installed via the printui
<#Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections' | 
ForEach-Object -Process {
    $PSItem |
    Get-ItemProperty -Name Printer |
    Select-Object -ExpandProperty Printer
}#>


#get list of shared printers from the print server
#Get-Printer -ComputerName print01 | where Shared -eq $true

#get the list of printui connections, but displays in a GUI
#rundll32 printui.dll,PrintUIEntry /ge 

#Printer User Interface

#Get-Process | where {$_.MainWindowTitle -like "Printer User Interface"}
#Set-Clipboard