<#
	Author: Chris Mitchell
	Date: 2020.07.09

Test's whether a user, computer, group, domain, or OU object is in Active Directory.
<##>
Set-Alias -Scope Global -Name TAO -Value Test-ADObject

function Test-ADObject {
    param (
        # AD object to test
        [Parameter(Mandatory=$true)]
        [object]
        $Identity,

        # AD object class type
        [Parameter(Mandatory=$true)]
        [string]$Class,
        
        # Domain server to search. Defaults to current PCs domain server.
        [string]$Server = (Get-ADDomain).Name
    )

    #switch on class
    switch ($Class.ToLower()) {
        "user"     { Get-ADUser $Identity -Server $Server | Out-Null }
        "computer" { Get-ADComputer $Identity -Server $Server | Out-Null }
        "group"    { Get-ADGroup -Identity $Identity -Server $Server | Out-Null }
        "domain"   { Get-ADDomain $Identity -Server $Server | Out-Null }
        "ou"       { Get-ADOrganizationalUnit -Identity $Identity -Server $Server | Out-Null }
        Default    { return "$Class is not a valid class. Accepted classes: User, Computer, Group, Domain, OU." }
    }

	# if any exception occurs, return FALSE
    trap [Exception] {
        return $false
    }
    return $true
}