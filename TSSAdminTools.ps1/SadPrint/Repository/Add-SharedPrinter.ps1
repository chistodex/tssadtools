<#
    Author: Chris Mitchell
    Date:   2020.05.20
    RevisionDate: 2020.10.22
#>

function Add-SharedPrinter {
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $ENV:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string[]]$Printer,
        [string]$PrintServer = "print01"
    )

    
    #need to add: check for whole printer share or just partial printer share, match best case and prompt to continue
    if (Test-Connection -ComputerName $PrintServer -Count 1 -Quiet) {
        foreach ($computer in $ComputerName) {
            if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
                foreach ($pinter in $Printer) {
                    $PrinterShare = "\\$PrintServer\$printer"
                    rundll32 printui.dll,PrintUIEntry /c\\$computer /ga /q /z /n$PrinterShare
                }
                
            } else {
                Write-Error "$computer is not available"
            }
        }
    } else {
        Write-Error "$printServer is not available"
    }

    #error handling
    # check that client is reachable
    # check to make sure the printer exists on the print server
    # check to make sure the printer doesn't already exist on the client
}



#EXAMPLE
#Add-SharedPrinter -ComputerName 10.17.3.68 -SharedPrinter WKH06-P16735
#Add-SharedPrinter -ComputerName WKH06-D32131,WKH06-D32094,WK-H06-T05 -SharedPrinter WKH06-P16735