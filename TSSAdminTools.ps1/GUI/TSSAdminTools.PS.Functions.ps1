function Get-Xaml {
    param (
        [string]$Path
    )
    
    [XML]$Xaml = Get-Content -Path $Path
    [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $Xaml))
}

function Clear-PrintQueue {
    param (
        $ComputerName = $ENV:COMPUTERNAME
    )

    if (Test-Path \\$ComputerName\c$\Windows\System32\PRINTERS\) {
        Get-Service -ComputerName $ComputerName -Name spooler | Stop-Service
        Remove-Item -Path \\$ComputerName\c$\Windows\System32\spool\PRINTERS\* -Force
        Get-Service -ComputerName $ComputerName -Name spooler | Start-Service
    } else {
        return "Error: $ComputerName is not reachable."
    }
}

function Get-CMSoftwareList {
    param (
        $ComputerName = $env:COMPUTERNAME
    )

    Import-Module -Name "\\cm01\d$\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -cmdlet Invoke-CMReport
    $DriveName = "DO1"
    if ($null -eq (Get-PSDrive $DriveName -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name $DriveName -PSProvider CMSite -Root CM01
    }

    Push-Location "$($DriveName):\"
    [string]$reportpath = 'Asset Intelligence/Software 02E - Installed software on a specific computer'
    Invoke-CMReport -reportPath $reportpath -SiteCode $DriveName -ReportParameter @{'Computer Name' = $ComputerName} #-OutputFormat ''
    Pop-Location
    Remove-PSDrive -Name $DriveName
}

function Add-CMDeviceToCollection {
    param(
        [string]$ComputerName = $env:COMPUTERNAME,
        #!!!!!!!Currently Moves device to adobe pro OU needs work to be modular!!!!!!!#
        [string]$CollectionId = (Get-CMcollection -name "Acrobat Pro").CollectionID,
        [string]$PcId = (Get-CMDevice -name $ComputerName).ResourceID,
        [string]$DriveName = "DO1"
    )
    Import-Module -Name "\\cm01\d$\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -Cmdlet Get-CMDevice, Get-CMCollection, Add-CMDeviceCollectionDirectMembershipRule, Remove-CMCollectionMembershipRule -Function Remove-CMDeviceCollectionDirectMembershipRule -Force

    if ($null -eq (Get-PSDrive $DriveName -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name $DriveName -PSProvider CMSite -Root CM01
    }

    Set-Location "$($DriveName):\"

    Add-CMDeviceCollectionDirectMembershipRule -CollectionId $CollectionId -ResourceId $PcId -force
}

function Remove-CMDeviceFromCollection {
    param(
        [string]$ComputerName = $env:COMPUTERNAME,
        #!!!!!!!Currently Moves device to adobe pro OU needs work to be modular!!!!!!!#
        [string]$CollectionId = (Get-CMcollection -name "Acrobat Pro").CollectionID,
        [string]$PcId = (Get-CMDevice -name $ComputerName).ResourceID,
        [string]$DriveName = "DO1"
    )
    Import-Module -Name "\\cm01\d$\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -Cmdlet Get-CMDevice, Get-CMCollection, Add-CMDeviceCollectionDirectMembershipRule, Remove-CMCollectionMembershipRule -Function Remove-CMDeviceCollectionDirectMembershipRule -Force

    if ($null -eq (Get-PSDrive $DriveName -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name $DriveName -PSProvider CMSite -Root CM01
    }

    Set-Location "$($DriveName):\"

    Remove-CMDeviceCollectionDirectMembershipRule -CollectionId $CollectionId -ResourceId $PcId -force
}

function Set-InfoPage {
    $TargetPc_TextBox.Text = $ENV:COMPUTERNAME
    $TargetPc_TextBox2.Text = $TargetPc_TextBox.Text
    $IPAddress_TextBox.Text = ((Test-Connection $TargetPc_TextBox.Text -Count 1).IPV4Address).IPAddressToString
    
}