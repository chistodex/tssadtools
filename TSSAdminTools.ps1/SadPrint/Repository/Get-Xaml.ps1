<#
    Author: Christopher Mitchell
    Date: 2020.08.01
#>

function Get-Xaml {
    param (
        [string]$Path
    )
    
    [XML]$Xaml = Get-Content -Path $Path
    [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $Xaml))
}