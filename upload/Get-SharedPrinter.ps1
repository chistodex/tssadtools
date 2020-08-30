<#
    Author: Chris Mitchell
    Date:   2020.05.20
#>

function Get-SharedPrinter {
    [CmdletBinding()]
    Param(
        [string[]]$ComputerName = $ENV:COMPUTERNAME
    )

    foreach ($computer in $ComputerName) {
        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
            rundll32 printui.dll,PrintUIEntry /c\\$computer /ge
        } else {
            Write-Host "$computer is not available"
        }
    }
}