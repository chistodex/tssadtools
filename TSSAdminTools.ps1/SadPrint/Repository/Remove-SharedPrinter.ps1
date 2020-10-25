<#
    Author: Chris Mitchell
    Date: 2020.09.09
    RevisionDate: 2020.10.22
#>

function Remove-SharedPrinter {
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $ENV:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string]$Printer,
        [string]$PrintServer = "print01"
    )

    $PrinterShare = "\\$PrintServer\$Printer"
    #need to add: check for whole printer share or just partial printer share, match best case and prompt to continue
    if (Test-Connection -ComputerName $PrintServer -Count 1 -Quiet) {
        foreach ($computer in $ComputerName) {
            if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
                rundll32 printui.dll,PrintUIEntry /c\\$computer /gd /q /n$PrinterShare
            } else {
                Write-Error "$computer is not available"
            }
        }
    } else {
        Write-Error "$printServer is not available"
    }
}