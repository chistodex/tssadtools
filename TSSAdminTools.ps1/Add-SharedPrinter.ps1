<#
    Author: Chris Mitchell
    Date:   2020.05.20
#>

function Add-SharedPrinter {
    [CmdletBinding()]
    Param(
        [string[]]$ComputerName = $ENV:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string]$SharedPrinter,
        [string]$PrintServer = "print01"
    )

    $PrinterShare = "\\$PrintServer\$SharedPrinter"
    #need to add: check for whole printer share or just partial printer share, match best case and prompt to continue
    if (Test-Connection -ComputerName $PrintServer -Count 1 -Quiet) {
        foreach ($computer in $ComputerName) {
            if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
                rundll32 printui.dll,PrintUIEntry /c\\$computer /ga /z /n$PrinterShare
            } else {
                Write-Host "$computer is not available"
            }
        }
    } else {
        Write-Host "$printServer is not available"
    }

    #error handling
    # check that client is reachable
    # check to make sure the printer exists on the print server
    # check to make sure the printer doesn't already exist on the client
}