#Add-Type -AssemblyName PresentationCore,PresentationFramework,System.Windows.Forms,System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework,System.Drawing
.$PSScriptRoot\TSSAdminTools.PS.Functions.ps1

$MainWindow = Get-Xaml -Path $PSScriptRoot\TSSAdminTools.xaml
$MainWindow.Icon = "$PSSCriptRoot\tssadmin2.ico"
$InfoPage = $MainWindow.FindName("InfoPage")
$ScriptsPage = $MainWindow.FindName("ScriptsPage")
$DocumentationPage = $MainWindow.FindName("DocumentationPage")
$AboutPage = $MainWindow.FindName("AboutPage")
$IPAddress_TextBox = $MainWindow.FindName("IPAddress_TextBox")

$InfoPage_Button = $MainWindow.FindName("InfoPage_Button")
$InfoPage_Button.Add_Click({
    $InfoPage_Button.Background = "White"
    $InfoPage.Visibility = 0
    $ScriptsPage_Button.Background = "#FFDDDDDD"
    $ScriptsPage.Visibility = 2
    $DocumentationPage_Button.Background = "#FFDDDDDD"
    $DocumentationPage.Visibility = 2
    $AboutPage_Button.Background = "#FFDDDDDD"
    $AboutPage.Visibility = 2
})

$ScriptsPage_Button = $MainWindow.FindName("ScriptsPage_Button")
$ScriptsPage_Button.Add_Click({
    $InfoPage_Button.Background = "#FFDDDDDD"
    $InfoPage.Visibility = 2
    $ScriptsPage_Button.Background = "White"
    $ScriptsPage.Visibility = 0
    $DocumentationPage_Button.Background = "#FFDDDDDD"
    $DocumentationPage.Visibility = 2
    $AboutPage_Button.Background = "#FFDDDDDD"
    $AboutPage.Visibility = 2
})

$DocumentationPage_Button = $MainWindow.FindName("DocumentationPage_Button")
$DocumentationPage_Button.Add_Click({
    $InfoPage_Button.Background = "#FFDDDDDD"
    $InfoPage.Visibility = 2
    $ScriptsPage_Button.Background = "#FFDDDDDD"
    $ScriptsPage.Visibility = 2
    $DocumentationPage_Button.Background = "White"
    $DocumentationPage.Visibility = 0
    $AboutPage_Button.Background = "#FFDDDDDD"
    $AboutPage.Visibility = 2
})

$AboutPage_Button = $MainWindow.FindName("AboutPage_Button")
$AboutPage_Button.Add_Click({
    $InfoPage_Button.Background = "#FFDDDDDD"
    $InfoPage.Visibility = 2
    $ScriptsPage_Button.Background = "#FFDDDDDD"
    $ScriptsPage.Visibility = 2
    $DocumentationPage_Button.Background = "#FFDDDDDD"
    $DocumentationPage.Visibility = 2
    $AboutPage_Button.Background = "White"
    $AboutPage.Visibility = 0
})

$TargetPc_TextBox = $MainWindow.FindName("TargetPC_TextBox")
$TargetPc_TextBox2 = $MainWindow.FindName("TargetPC_TextBox2")

#Get-NetAdapter MAC
#Get-NetIPAddress IP
#Get-NetIPAddress | Where-Object -FilterScript { $_.ValidLifetime -Lt ([TimeSpan]::FromDays(1)) }
Set-InfoPage

$Exit_Button = $MainWindow.FindName("Exit_Button")
$Exit_Button.Add_Click({
    $MainWindow.Close()
})


    # 0 = visibile
    # 1 = hidden
    # 2 = collapsed


<# Has to be the last line #>
[void]$MainWindow.ShowDialog()