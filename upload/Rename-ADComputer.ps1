function Rename-ADComputer {
    param (
        [string]$ComputerName = $ENV:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string]$NewName,
        [Parameter(Mandatory=$true)]
        [string]$UserName,
        [Parameter(Mandatory=$true)]
        [securestring]$Password
    )
    $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName,$Password
    Rename-Computer -ComputerName $ComputerName -NewName $NewName -Force -Restart -DomainCredential $Credentials
}

Rename-ADComputer -ComputerName WKH04-I32129 -NewName WKH04-D32129