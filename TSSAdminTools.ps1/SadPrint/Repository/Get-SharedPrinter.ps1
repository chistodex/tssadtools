<#
    Author: Chris Mitchell, Trent Wallers
    Date: 2020.09.04
    RevisionDate: 2020.10.23

    Creates an array object of shared printers installed via the PrintUI.
#>
<#
    .SYNOPSIS
    Gets a list of printers added via the PrintUI and added locally.
    
    .DESCRIPTION
    

    .PARAMETER Param1

    .INPUTS
    Can take a single a computer a or an array of computers.

    .OUTPUTS
    Only outputs an object array.

    .EXAMPLE
    Get-SharedPrinter -ComputerName OC-IT-01

    .EXAMPLE
    Get-SharedPrinter OC-IT-01

    .EXAMPLE
    $ComputerList = "OC-IT-01","OC-IT-02","OC-IT-03"
    Get-SharedPrinter $ComputerList
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
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "Type" -Value "Connection"
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "DriverName" -Value $null
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "Portname" -Value $null
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "Shared" -Value $true
                        $PrinterObject | Add-Member -MemberType NoteProperty -Name "PrinUI" -Value $true
                        $PrinterArray.Add($PrinterObject) | Out-Null
                        $PrinterObject = New-Object System.Object
                    } else {
                        $tmpLine = $line.Split(":")
                        $tmpLine[0] = $tmpLine[0] -replace '\s+', ''
                        $tmpLine[1] = $tmpLine[1].Trim()
                        
                        if ($tmpLine[0] -eq "PrinterName") {
                            $tmpLine[0] = "Name"
                            $tmp = $tmpLine[1].Split("\")
                            $tmpLine[1] = $tmp[$tmp.Length - 1]
                        } else {
                            $tmpLine[1] = $tmpLine[1] -replace '\\', ''
                        }

                        $PrinterObject | Add-Member -MemberType NoteProperty -Name $tmpLine[0] -Value $tmpLine[1].Trim()
                    } 
                }

            } else {
                Write-Error "$computer has no shared printers"
            }
            $PrinterArray += Get-MyPrinter -ComputerName $computer
        } else {
            Write-Error "$computer is not available"
        }
    }

    Remove-Item $TempFile
    $PrinterArray
}

function Get-MyPrinter {
    [CmdletBinding()]
    param (
        $ComputerName
    )

    if ($ComputerName -eq $ENV:COMPUTERNAME) {
        $PrinterList = Get-Printer
    } else {
        $PrinterList = Get-Printer -ComputerName $ComputerName
    }

    #$PrinterList | Format-Table

    $PrinterArray = $(foreach ($printer in $PrinterList) {
        [PSCustomObject]@{
            'Name' = $printer.Name
            'ComputerName' = $ComputerName
            'ServerName' = if ($printer.Shared) { $printer.ComputerName } else { '' }
            'Type' = $printer.Type
            'DriverName' = $printer.DriverName
            'PortName' = $printer.PortName
            'Shared' = $printer.Shared
            'Published' = $printer.Published
            'PrintUI' = $false
        }
    })

    $PrinterArray
}