<#
    Author: Chris Mitchell
    Date: 2020.10.19
    LastRevised: 2020.10.22
#>
<#
    .SYNOPSIS
    Printer UI for managing printers added via the PrintUI.
    
    .DESCRIPTION
    Gets a list of shared printers from a print server and allows to add or remove printers via the PrintUI.
#>


Add-Type -AssemblyName PresentationCore,PresentationFramework,System.Drawing,System.Windows.Forms
Import-Module $PSScriptRoot\repository.psm1

$Target = [PSCustomObject]@{
    'Computer' = $ENV:COMPUTERNAME
    'PrintServer' = 'print01'
    'AddPrinter' = ''
    'RemovePrinter' = ''
}
$error.Clear()

# Instantiate controls
$MainWindow                 = Get-Xaml -Path $PSScriptRoot\SadPrint.xaml
$MainWindow.Icon            = "$PSSCriptRoot\icon.ico"

$AddPrinter_Button          = $MainWindow.FindName("AddPrinter_Button")
$AddPrinter_Button.Add_Click({
    $Target.AddPrinter = $AddPrinter_ComboBox.SelectedItem
    Press-PrinterButton -ComboBox $AddPrinter_ComboBox -Add
} )

$AddPrinter_ComboBox        = $MainWindow.FindName("AddPrinter_ComboBox")

$ComputerName_Button        = $MainWindow.FindName("ComputerName_Button")
$ComputerName_Button.Add_Click({
    $Target.Computer = $ComputerName_TextBox.Text
    Press-GetButton -ComboBox $RemovePrinter_ComboBox -ComputerName $Target.Computer -Button $ComputerName_Button
})

$ComputerName_TextBox       = $MainWindow.FindName("ComputerName_TextBox")
$ComputerName_TextBox.Text  = $Target.Computer

$Exit_Button                = $MainWindow.FindName("Exit_Button")
$Exit_Button.Add_Click({
    $MainWindow.Close()
})

$Output_TextBox             = $MainWindow.FindName("Output_TextBox")

$PrintServer_Button         = $MainWindow.FindName("PrintServer_Button")
$PrintServer_Button.Add_Click({
    $Target.PrintServer = $PrintServer_TextBox.Text
    Press-GetButton -ComboBox $AddPrinter_ComboBox -ComputerName $Target.PrintServer -Button $PrintServer_Button
})

$PrintServer_TextBox        = $MainWindow.FindName("PrintServer_TextBox")
$PrintServer_TextBox.Text   = $Target.PrintServer

$RemovePrinter_Button       = $MainWindow.FindName("RemovePrinter_Button")
$RemovePrinter_Button.Add_Click({
    $Target.RemovePrinter = $RemovePrinter_ComboBox.SelectedItem
    Press-PrinterButton -ComboBox $RemovePrinter_ComboBox
})

$RemovePrinter_ComboBox     = $MainWindow.FindName("RemovePrinter_ComboBox")

# FUNCTIONS
function Clear-ComboBox() {
    [CmdletBinding()]
    param (
        $ComboBox
    )
    $ComboBox.Items.Clear()
}

function Add-ToTextBox() {
    [CmdletBinding()]
    param (
        $TextBox,
        $Text
    )

    $NL = "`r`n" # newline

    $TextBox.AppendText("$Text" + "$NL") # append to textbox
    $TextBox.Select($TextBox.Text.Length, 0) # move textbox to the last line
    $TextBox.Focus() | Out-Null
    $TextBox.ScrollToCaret
}

function  Add-ToComboBox {
    param (
        $ComboBox,
        $List
    )

    foreach ($item in $List) {
        $ComboBox.Items.Add($item.Name) | Out-Null
    }
}

function Press-GetButton {
    [CmdletBinding()]
    param (
        $ComboBox,
        $ComputerName,
        $Button
    )

    Clear-ComboBox $ComboBox
    if (Test-Connection $ComputerName -Quiet -Count 1) {
        $Button.Background = "green"

        $PrinterList = Get-SharedPrinter -ComputerName $ComputerName 2>$null
        if ($error) {
            Add-ToTextBox $Output_TextBox $error
            $error.Clear()
        }

        Add-ToComboBox $ComboBox $PrinterList
        Add-ToTextBox $Output_TextBox "Printer list populated."
    } else {
        $Button.Background = "red"
        Add-ToTextBox $Output_TextBox "Host $ComputerName is unreachable."
    }
}

function Press-PrinterButton {
    [CmdletBinding()]
    param (
        $ComboBox,
        [switch]$Add   # Switch to add or remove printer
    )

    # Check if printer has been selected in ComboBox
    if ($ComboBox.SelectedItem) {
        
        # Add or Remove printer
        if ($Add) {
            Add-SharedPrinter -ComputerName $Target.Computer -Printer $Target.AddPrinter -PrintServer $Target.PrintServer 2>$null
        } else {
            Remove-SharedPrinter -ComputerName $Target.Computer -Printer $Target.RemovePrinter -PrintServer $Target.PrintServer 2>$null
        }
        # Clear selection so user knows something happened
        $ComboBox.SelectedIndex = -1
        # Clear the Remove printer box so that the the new set of printers can be loaded
        Clear-ComboBox $RemovePrinter_ComboBox
        
        # Get PrinterList
        $PrinterList = Get-SharedPrinter -ComputerName $Target.Computer 2>$null
        if ($error) {
            Add-ToTextBox $Output_TextBox $error
            $error.Clear()
        }
        
        # Populate ComboBox
        Add-ToComboBox $RemovePrinter_ComboBox $PrinterList
        Add-ToTextBox $Output_TextBox "Printer list populated."
    } else {
        # Throw error if no selection has been made
        Add-ToTextBox $Output_TextBox "No printer has been selected."
    }    
}

function Press-MyGetButton {
    [CmdletBinding()]
    param (
        $Computer,
        $Printer,
        $Button,
        [switch]$AddPrinter,
        [switch]$RemovePrinter
    )


    if ($AddPrinter) {
        Write-Host "Add"
    } 
    
    if ($RemovePrinter) {
        Write-Host "Remove"
    } 
    
    Write-Host "no"
<#
    Clear-ComboBox $ComboBox
    if (Test-Connection $ComputerName -Quiet -Count 1) {
        $Button.Background = "green"

        $PrinterList = Get-SharedPrinter -ComputerName $ComputerName 2>$null
        if ($error) {
            Add-ToTextBox $Output_TextBox $error
            $error.Clear()
        }

        Add-ToComboBox $ComboBox $PrinterList
        Add-ToTextBox $Output_TextBox "Printer list populated."
    } else {
        $Button.Background = "red"
        Add-ToTextBox $Output_TextBox "Host $ComputerName is unreachable."
    }#>
}

# ON LOAD EVENTS
Write-Host "Loading..."
Press-GetButton -ComboBox $RemovePrinter_ComboBox -ComputerName $ComputerName_TextBox.Text -Button $ComputerName_Button
Press-GetButton -ComboBox $AddPrinter_ComboBox -ComputerName $PrintServer_TextBox.Text -Button $PrintServer_Button

# Has to be the last line
[void]$MainWindow.ShowDialog()