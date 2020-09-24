<#
    Author: Chris Mitchell, Trent Wallers
    Date: 2020.09.04
    RevisionDate: 2020.09.24

    Creates an array object of shared printers installed via the PrintUI.
#>

function Get-SharedPrinter {
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $ENV:COMPUTERNAME
    )

    $TempFile = New-TemporaryFile                               # TempFile for holding printer output from printui
    $PrinterList = $null                                        # holds the list of printers from the TempFile
    $PrinterObject = New-Object System.Object                   # an object for storing the printer details
    $PrinterArray = New-Object System.Collections.ArrayList     # an array for storing multiple printer objects

    foreach ($computer in $ComputerName) {
        # delete the contents of the TempFile so that the previo
        Clear-Content $TempFile

        # make sure computer is reachable
        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {

            # get the list of printers installed via the printui and wait until it finishes writing to TempFile
            Start-Process rundll32.exe -ArgumentList "printui.dll,PrintUIEntry","/c\\$computer","/ge","/f$TempFile" -Wait

            # check if TempFile has any printers in it
            if (Get-Content $TempFile) {
                $PrinterList = Get-Content $TempFile

                # create PrinterObjects from the PrinterList and add them to the PrinterArray
                foreach ($line in $PrinterList) {
                    if ($line -eq '') {
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computer
                        $PrinterArray.Add($PrinterObject) | Out-Null
                        $PrinterObject = New-Object System.Object
                    } else {
                        $tmpLine = $line.Split(":")
                        $tmpLine[0] = $tmpLine[0] -replace '\s+', ''
                        $tmpLine[1] = $tmpLine[1].Trim()
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name $tmpLine[0] -Value $tmpLine[1].Trim()
                    } 
                }
            } else {
                Write-Host "$computer has no printers"
            }
        } else {
            Write-Host "$computer is not available"
        }
    }

    Remove-Item $TempFile
    $PrinterArray
}
