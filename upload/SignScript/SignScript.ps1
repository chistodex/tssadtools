<#
    Author: Chris Mitchell
    Date: 2020.07.24
    LastRevised: 2020.07.24
#>

Add-Type -AssemblyName PresentationCore,PresentationFramework,System.Drawing,System.Windows.Forms

[XML]$Xaml = @"
<Window x:Name="MainWindow_Window"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Certificate Signing"
    Width="445" ResizeMode="NoResize" Height="Auto" SizeToContent="Height"
    >

    <StackPanel Orientation="Vertical" HorizontalAlignment="Center">
        <StackPanel Margin="0,5,0,0"  Orientation="Horizontal" HorizontalAlignment="Center">
            <StackPanel Orientation="Vertical">
                <Label Content="Script:" Height="25" Margin="5" Width="65" HorizontalAlignment="Right" />
                <Label Content="Certificate:" Height="25" Margin="5" Width="65" HorizontalAlignment="Right" />
            </StackPanel>
            <StackPanel Orientation="Vertical">
                <TextBox x:Name="ScriptPath_TextBox" Height="25" Margin="5" Width="200" />
                <ComboBox x:Name="CertPath_ComboBox" Height="25" Margin="5" Width="200" />
            </StackPanel>
            <StackPanel Orientation="Vertical">
                <Button x:Name="ScriptPath_Button" Height="25" Margin="5" Width="75">Browse...</Button>
                <Label Height="25" Margin="5" Width="75" />
            </StackPanel>
        </StackPanel>
        <Label x:Name="Done_Label" Content="Done! Or failed..." Height="30" Margin="10" Width="180" HorizontalContentAlignment="Center" HorizontalAlignment="Center" Visibility="Hidden" />
        <StackPanel Orientation="Horizontal">
            <Button x:Name="Sign_Button" Height="50" Margin="10" Width="180">Sign</Button>
            <Button x:Name="Exit_Button"  Height="50" Margin="10" Width="180">Exit</Button>
        </StackPanel>
    </StackPanel>
</Window>
"@

$TimeStampServer = "http://timestamp.digicert.com"
$MainWindow = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $Xaml))
$Done_Label = $MainWindow.FindName("Done_Label")
$CertPath_ComboBox = $MainWindow.FindName("CertPath_ComboBox")
$ScriptPath_TextBox = $MainWindow.FindName("ScriptPath_TextBox")
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog

$Certs = Get-ChildItem Cert:\CurrentUser\My\

foreach ($cert in $Certs) {
    $CertPath_ComboBox.Items.Add($cert) | Out-Null
}

$ScriptPath_Button = $MainWindow.FindName("ScriptPath_Button")
$ScriptPath_Button.Add_Click({
    #$FileBrowser.InitialDirectory = Get-Location
    [void]$FileBrowser.ShowDialog()

    # Check if a file was selected
    if ($FileBrowser.FileName) {
        $ScriptPath_TextBox.Text = $FileBrowser.FileName

        # Change label to be the scripts signed state
        $Done_Label.Content = (Get-AuthenticodeSignature -FilePath $FileBrowser.FileName).Status
        $Done_Label.Visibility = 0
        # at some point make the last used directory the initial directory, for some reason not working
    }
})

$Sign_Button = $MainWindow.FindName("Sign_Button")
$Sign_Button.Add_Click({
    # Check if script was selected
    if ($FileBrowser.FileName) {
        # Check if cert was selected
        if ($CertPath_ComboBox.SelectedItem) {
            # Sign script
            Set-AuthenticodeSignature -FilePath $FileBrowser.FileName -Certificate $CertPath_ComboBox.SelectedItem -TimestampServer $TimeStampServer

        }
        $Done_Label.Content = (Get-AuthenticodeSignature -FilePath $FileBrowser.FileName).Status
    }
    
})

$Exit_Button = $MainWindow.FindName("Exit_Button")
$Exit_Button.Add_Click({
    $MainWindow.Close()
})

# Has to be the last line
[void]$MainWindow.ShowDialog()
# SIG # Begin signature block
# MIIhZgYJKoZIhvcNAQcCoIIhVzCCIVMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXM1qt41E0LDRq4y2cJXFsoju
# a0egghx+MIIGajCCBVKgAwIBAgIQAwGaAjr/WLFr1tXq5hfwZjANBgkqhkiG9w0B
# AQUFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVk
# IElEIENBLTEwHhcNMTQxMDIyMDAwMDAwWhcNMjQxMDIyMDAwMDAwWjBHMQswCQYD
# VQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJTAjBgNVBAMTHERpZ2lDZXJ0IFRp
# bWVzdGFtcCBSZXNwb25kZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCjZF38fLPggjXg4PbGKuZJdTvMbuBTqZ8fZFnmfGt/a4ydVfiS457VWmNbAklQ
# 2YPOb2bu3cuF6V+l+dSHdIhEOxnJ5fWRn8YUOawk6qhLLJGJzF4o9GS2ULf1ErNz
# lgpno75hn67z/RJ4dQ6mWxT9RSOOhkRVfRiGBYxVh3lIRvfKDo2n3k5f4qi2LVkC
# YYhhchhoubh87ubnNC8xd4EwH7s2AY3vJ+P3mvBMMWSN4+v6GYeofs/sjAw2W3rB
# erh4x8kGLkYQyI3oBGDbvHN0+k7Y/qpA8bLOcEaD6dpAoVk62RUJV5lWMJPzyWHM
# 0AjMa+xiQpGsAsDvpPCJEY93AgMBAAGjggM1MIIDMTAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDCCAb8GA1UdIASC
# AbYwggGyMIIBoQYJYIZIAYb9bAcBMIIBkjAoBggrBgEFBQcCARYcaHR0cHM6Ly93
# d3cuZGlnaWNlcnQuY29tL0NQUzCCAWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkA
# IAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUA
# IABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAA
# bwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEA
# bgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIA
# ZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkA
# bABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUA
# ZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYAZQByAGUAbgBjAGUALjALBglg
# hkgBhv1sAxUwHwYDVR0jBBgwFoAUFQASKxOYspkH7R7for5XDStnAs0wHQYDVR0O
# BBYEFGFaTSS2STKdSip5GoNL9B6Jwcp9MH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6
# Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDig
# NqA0hjJodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURD
# QS0xLmNybDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5jcnQwDQYJKoZIhvcNAQEFBQAD
# ggEBAJ0lfhszTbImgVybhs4jIA+Ah+WI//+x1GosMe06FxlxF82pG7xaFjkAneNs
# hORaQPveBgGMN/qbsZ0kfv4gpFetW7easGAm6mlXIV00Lx9xsIOUGQVrNZAQoHuX
# x/Y/5+IRQaa9YtnwJz04HShvOlIJ8OxwYtNiS7Dgc6aSwNOOMdgv420XEwbu5AO2
# FKvzj0OncZ0h3RTKFV2SQdr5D4HRmXQNJsQOfxu19aDxxncGKBXp2JPlVRbwuwqr
# HNtcSCdmyKOLChzlldquxC5ZoGHd2vNtomHpigtt7BIYvfdVVEADkitrwlHCCkiv
# sNRu4PQUCjob4489yq9qjXvc2EQwggbNMIIFtaADAgECAhAG/fkDlgOt6gAK6z8n
# u7obMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdp
# Q2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0Rp
# Z2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0wNjExMTAwMDAwMDBaFw0yMTEx
# MTAwMDAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFz
# c3VyZWQgSUQgQ0EtMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOiC
# LZn5ysJClaWAc0Bw0p5WVFypxNJBBo/JM/xNRZFcgZ/tLJz4FlnfnrUkFcKYubR3
# SdyJxArar8tea+2tsHEx6886QAxGTZPsi3o2CAOrDDT+GEmC/sfHMUiAfB6iD5IO
# UMnGh+s2P9gww/+m9/uizW9zI/6sVgWQ8DIhFonGcIj5BZd9o8dD3QLoOz3tsUGj
# 7T++25VIxO4es/K8DCuZ0MZdEkKB4YNugnM/JksUkK5ZZgrEjb7SzgaurYRvSISb
# T0C58Uzyr5j79s5AXVz2qPEvr+yJIvJrGGWxwXOt1/HYzx4KdFxCuGh+t9V3CidW
# fA9ipD8yFGCV/QcEogkCAwEAAaOCA3owggN2MA4GA1UdDwEB/wQEAwIBhjA7BgNV
# HSUENDAyBggrBgEFBQcDAQYIKwYBBQUHAwIGCCsGAQUFBwMDBggrBgEFBQcDBAYI
# KwYBBQUHAwgwggHSBgNVHSAEggHJMIIBxTCCAbQGCmCGSAGG/WwAAQQwggGkMDoG
# CCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9z
# aXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAA
# bwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMA
# dABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgA
# ZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
# ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4A
# dAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAA
# YQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIA
# ZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTAS
# BgNVHRMBAf8ECDAGAQH/AgEAMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGB
# BgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIr
# E5iymQftHt+ivlcNK2cCzTAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823I
# DzANBgkqhkiG9w0BAQUFAAOCAQEARlA+ybcoJKc4HbZbKa9Sz1LpMUerVlx71Q0L
# QbPv7HUfdDjyslxhopyVw1Dkgrkj0bo6hnKtOHisdV0XFzRyR4WUVtHruzaEd8wk
# pfMEGVWp5+Pnq2LN+4stkMLA0rWUvV5PsQXSDj0aqRRbpoYxYqioM+SbOafE9c4d
# eHaUJXPkKqvPnHZL7V/CSxbkS3BMAIke/MV5vEwSV/5f4R68Al2o/vsHOE8Nxl2R
# uQ9nRc3Wg+3nkg2NsWmMT/tZ4CMP0qquAHzunEIOz5HXJ7cW7g/DvXwKoO4sCFWF
# IrjrGBpN/CohrUkxg0eVd3HcsRtLSxwQnHcUwZ1PL1qVCCkQJjCCB4IwggZqoAMC
# AQICExQAACrLzK8f7TK4LeEAAgAAKsswDQYJKoZIhvcNAQELBQAwgYUxEjAQBgoJ
# kiaJk/IsZAEZFgJ1czESMBAGCgmSJomT8ixkARkWAmNhMRMwEQYKCZImiZPyLGQB
# GRYDazEyMRcwFQYKCZImiZPyLGQBGRYHdHVybG9jazEWMBQGCgmSJomT8ixkARkW
# BnRzZG5ldDEVMBMGA1UEAxMMVFNETkVULVNVQkNBMB4XDTIwMDcyMDIyMjY1NVoX
# DTIxMDcyMDIyMjY1NVowgasxEjAQBgoJkiaJk/IsZAEZFgJ1czESMBAGCgmSJomT
# 8ixkARkWAmNhMRMwEQYKCZImiZPyLGQBGRYDazEyMRcwFQYKCZImiZPyLGQBGRYH
# dHVybG9jazEWMBQGCgmSJomT8ixkARkWBnRzZG5ldDEcMBoGA1UECxMTVGVjaG5v
# bG9neSBTZXJ2aWNlczEdMBsGA1UEAxMUQ2hyaXN0b3BoZXIgTWl0Y2hlbGwwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC5LIXeN+NnBkiDvUK3kX3ft9m2
# 3oibQXrAZy9J7Rdd8aaBXgoqTMML+Qw3/V1ollBVKF0prFNEWeN6eIyIURFIdvft
# Fq2Lcjd3bJ83y+d8OEbIlzL4y/VbKVKwxzEKoX9zz7QO+h/R+3qXhYyS4DTL1bsN
# nMpZTQwzYrV32OH0HFPBYQARAaggQiz0v/whADGGm2JANSYyHgtZWT6Mdts3vu7v
# g94KCPPRKecDBomYJ5fVQ+4OJ5Y+PyfzVd2AOUhLCk0VJBLsK1H6BtkZ7vSc/kNk
# 7rpEZBIwW0CIqIZzsO11U84lri9lsc3g8gTFESnco2obaqp/E/xYdDzN7CZBAgMB
# AAGjggPBMIIDvTA9BgkrBgEEAYI3FQcEMDAuBiYrBgEEAYI3FQiG35duguGdOIW1
# kxOCqKJuhLeADR+Frt18gtX6OAIBZAIBAzATBgNVHSUEDDAKBggrBgEFBQcDAzAO
# BgNVHQ8BAf8EBAMCB4AwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNV
# HQ4EFgQUUIMlWVEsksHvVH3tKmjHF+9v/YYwHwYDVR0jBBgwFoAU+/r8WaJuHq5T
# pBw5fbln10Wtzd0wggFnBgNVHR8EggFeMIIBWjCCAVagggFSoIIBToaBzmxkYXA6
# Ly8vQ049VFNETkVULVNVQkNBLENOPVRTRE5FVC1TdWJDQSxDTj1DRFAsQ049UHVi
# bGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlv
# bixEQz10c2RuZXQsREM9dHVybG9jayxEQz1rMTIsREM9Y2EsREM9dXM/Y2VydGlm
# aWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1
# dGlvblBvaW50hkhodHRwOi8vVFNETkVULVN1YkNBLnRzZG5ldC50dXJsb2NrLmsx
# Mi5jYS51cy9DZXJ0RW5yb2xsL1RTRE5FVC1TVUJDQS5jcmyGMWh0dHA6Ly9wa2ku
# dHVybG9jay5rMTIuY2EudXMvcGtpL1RTRE5FVC1TVUJDQS5jcmwwggFVBggrBgEF
# BQcBAQSCAUcwggFDMIHBBggrBgEFBQcwAoaBtGxkYXA6Ly8vQ049VFNETkVULVNV
# QkNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNl
# cyxDTj1Db25maWd1cmF0aW9uLERDPXRzZG5ldCxEQz10dXJsb2NrLERDPWsxMixE
# Qz1jYSxEQz11cz9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlm
# aWNhdGlvbkF1dGhvcml0eTB9BggrBgEFBQcwAoZxaHR0cDovL1RTRE5FVC1TdWJD
# QS50c2RuZXQudHVybG9jay5rMTIuY2EudXMvQ2VydEVucm9sbC9UU0RORVQtU3Vi
# Q0EudHNkbmV0LnR1cmxvY2suazEyLmNhLnVzX1RTRE5FVC1TVUJDQSgyKS5jcnQw
# NgYDVR0RBC8wLaArBgorBgEEAYI3FAIDoB0MG2NtaXRjaGVsbEB0dXJsb2NrLmsx
# Mi5jYS51czANBgkqhkiG9w0BAQsFAAOCAQEABq7WV7BzgmXD0IlpPvfOHzDckk+u
# wDq7Vt3a6gxdZ9id5b4SfRCrT2S5uc0Cie0hYnHmr231H5pI2iKEO6VJP3wcisn6
# 4ihVhbsDsGtvC5vfWAcZEB/ZFnLFEf4wrOZc+0ZkG5104yEbejtOaBQwf+UCdibN
# lz1yLpjDRP1TjTUCqZi8LXdVvGDktU5v4oYm8Wzm8SPkwmXSxsUQZp1o3TdG/nx1
# P9xUnFbw1TWdkzpY3uhTnRFLlofHt4pIRZBOl8pu5QTX2AoDuoQ2ukXe5ZJ4DjH9
# AJ2gQzAJWBsk4NjvHV3H1ABN0q7EaAmTgSD+PuuNygRH3tdvsyBNs1MbHTCCB7Uw
# ggWdoAMCAQICE1kAAAAMNuDA69ufzf8AAQAAAAwwDQYJKoZIhvcNAQENBQAwgYYx
# EjAQBgoJkiaJk/IsZAEZFgJ1czESMBAGCgmSJomT8ixkARkWAmNhMRMwEQYKCZIm
# iZPyLGQBGRYDazEyMRcwFQYKCZImiZPyLGQBGRYHdHVybG9jazEWMBQGCgmSJomT
# 8ixkARkWBnRzZG5ldDEWMBQGA1UEAxMNVFNETkVULVJPT1RDQTAeFw0xOTAyMjAx
# OTMwMDdaFw0yNDAyMjAxOTQwMDdaMIGFMRIwEAYKCZImiZPyLGQBGRYCdXMxEjAQ
# BgoJkiaJk/IsZAEZFgJjYTETMBEGCgmSJomT8ixkARkWA2sxMjEXMBUGCgmSJomT
# 8ixkARkWB3R1cmxvY2sxFjAUBgoJkiaJk/IsZAEZFgZ0c2RuZXQxFTATBgNVBAMT
# DFRTRE5FVC1TVUJDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKz3
# u6BhJGr1gS4VF9Er1Yismf2CJwM4uPWqooqWm8gYnq4M6/EKeCeYyPqQe1kuMtyg
# OSjMtE3OgsoKL3zrj7kJmWvEN26w6fcKazxSqtpnD5or3Gj0pQEWT4Fyt/7S0NUD
# 4Q7Iqub/e3Gp7pbdS5jksggNceQuxd5nSPxLx0wogJTS7iSzj0ELAdM9Xwm77Cc8
# KaU25lxEKxTSV2sZisCl4NjNgedjhY3vh66BOTgpTJJKg2IsMP0dTfbGPIbjNJB7
# ZCZ+AhQmrUeSH8HqdBAg9cSaIPLO+xPc2jwoDMayaUK5cFv3jtPQIzVSa/A4f2Mf
# 2/UyLWLrr+JI0KSf2EkCAwEAAaOCAxkwggMVMBAGCSsGAQQBgjcVAQQDAgECMCMG
# CSsGAQQBgjcVAgQWBBTSm2YxYb8uGSCG4vbfIxU5vXW82TAdBgNVHQ4EFgQU+/r8
# WaJuHq5TpBw5fbln10Wtzd0wGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYD
# VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUdFy5/y9BLKkW
# 5rcnnhGmRmnAu40wggEeBgNVHR8EggEVMIIBETCCAQ2gggEJoIIBBYaB0GxkYXA6
# Ly8vQ049VFNETkVULVJPT1RDQSxDTj1UU0RORVQtUm9vdENBLENOPUNEUCxDTj1Q
# dWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0
# aW9uLERDPXRzZG5ldCxEQz10dXJsb2NrLERDPWsxMixEQz1jYSxEQz11cz9jZXJ0
# aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJp
# YnV0aW9uUG9pbnSGMGh0dHA6Ly90c2RuZXQtc3ViY2EvQ2VydEVucm9sbC9UU0RO
# RVQtUk9PVENBLmNybDCCAT8GCCsGAQUFBwEBBIIBMTCCAS0wgcIGCCsGAQUFBzAC
# hoG1bGRhcDovLy9DTj1UU0RORVQtUk9PVENBLENOPUFJQSxDTj1QdWJsaWMlMjBL
# ZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXRz
# ZG5ldCxEQz10dXJsb2NrLERDPWsxMixEQz1jYSxEQz11cz9jQUNlcnRpZmljYXRl
# P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTBmBggrBgEF
# BQcwAoZaaHR0cDovL3RzZG5ldC1zdWJjYS9DZXJ0RW5yb2xsL1RTRE5FVC1Sb290
# Q0EudHNkbmV0LnR1cmxvY2suazEyLmNhLnVzX1RTRE5FVC1ST09UQ0EoMSkuY3J0
# MA0GCSqGSIb3DQEBDQUAA4ICAQBnzpiOHkExo6L73Gtc539g2XQZ86nU/yv13Lqi
# 7aJDk1kBLbPlYktbyuBSVxE/f7D0MCdv+ftxkWeNKMFQMpTfCaH6abglu9YOcrGz
# mnJaxreZjfz5Xh5kaHhRIadgpdS1YUiaEWqPksNgwIgCtB9F/j2pHBigINsY14s1
# OcG5bIJ120XY2O6tVudY6FTs5BI0F4SEl0iga1ZxsmejJBnfi7t5iSZCj3xfWuzw
# Zh4biWjcLdmLb/4iR2aQy9dzW6Cfvsor8GJDiUKse4NuGUp4hQd3G/mvBG20od8H
# p6TIppxndkm2jQEKm/EnNs2h4OBKgNNiEN3N/7zo+BCvJ10ZL2KMhQWF2ositYHx
# 1NZYyIFIn+S2LOgVdbL5SxOa1NGaiNDwYAGyn1uPZWCp9O+xV4RefeuW8poABqkt
# fdXCJj5OZVYhJrYqByOGnlmLCUmsBHPg+XYTzhp9RJaVf40XpIKXBoouz38l6f5L
# DO6AKvna2Bt3zPkL2drLLF4aQl8Y2uExYL+2bghZ36R50LybhOD0oEG3hOl3t+5o
# HRaiqiLoC80SWkEiIaTwcGeFM0aNi3y+QHzzgf6pZS0xwq5cugYvsnSLyiXhBh5Z
# vbz+Zsw9XjHHIjL+KFX+iSCc4KvDmTss6WB3XbQ3suuafW7F5hTEMN41VE8LaDu0
# RghLhzGCBFIwggROAgEBMIGdMIGFMRIwEAYKCZImiZPyLGQBGRYCdXMxEjAQBgoJ
# kiaJk/IsZAEZFgJjYTETMBEGCgmSJomT8ixkARkWA2sxMjEXMBUGCgmSJomT8ixk
# ARkWB3R1cmxvY2sxFjAUBgoJkiaJk/IsZAEZFgZ0c2RuZXQxFTATBgNVBAMTDFRT
# RE5FVC1TVUJDQQITFAAAKsvMrx/tMrgt4QACAAAqyzAJBgUrDgMCGgUAoHgwGAYK
# KwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
# BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU
# hCR+59M2u2ckIiqPyZmvVVWqZ/MwDQYJKoZIhvcNAQEBBQAEggEAgDwjeA7wwcde
# DfJPYJtV8rDu/Z7T/IsTe8MI3z+2186pNY8Y9LaKZ/PqzIRdL0Hp4l2bhggHpT3X
# hNzd5o9pBZSWqyFgyTPRjhykrxbfYYve7x61K9ejfr6BK2mk6IEeXTQNxRHVeorh
# Un5zKz9sXomfAn/F2VJRTQPO+hnqmgcEseBPAaM/FCc0ZofxSO6rJFZv4jKEiWE5
# wbSXApx4z3fmHhQCjL7pYQ+nFbbDq8/0+KaL+WdEp6S6WXdCP1+/E3KgZI4qTmPG
# P1hffHZCnrJGkgAiPJzpGKDhuUovvPFAAJr5BPWlm793wyqeRfpI5rpdx+zpPGdy
# psKMPAwLhqGCAg8wggILBgkqhkiG9w0BCQYxggH8MIIB+AIBATB2MGIxCzAJBgNV
# BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
# Y2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMQIQAwGa
# Ajr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3
# DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNzI0MTgyODUxWjAjBgkqhkiG9w0BCQQx
# FgQUTI7cbEGpz2tOcceRse+/QNbGOnAwDQYJKoZIhvcNAQEBBQAEggEATisgcdgV
# i9lDA4svuJ6Kqix59gdqHhYKFZ3WnWPpJ6Np5ovS3/vHC0QlwpV+zhlzWavCxV+5
# cF3SWJrqYrHJ1VVJwDXEUdw1erxbUopQ+rXxCgtYY9E/oIbIbjvbCo/6lDYsQX1v
# DMkRcOuC7EXoaSYdycD4gJi3fg+VucdowXpSchuvwT1NEGyixjwPYBCGvfXFNLYD
# BMNht2XROGlED+/M8QRCBhpCBrvthVGNtH9RRS0iFQu4q/oIGdnphvoMNFkx9cIu
# 1i93OoItGB+scJcpWgPUp3vPL60AHWpnJ2oEx/UkAE687SQe2jgZLprXGLPgQEwA
# 4S4WbWxjDIEh7w==
# SIG # End signature block
