# TSSAdmin Tools - PowerShell

A collection of powershell commandlets.

**SignScript** - as of July 1st, as per Network Supervisor, scripts ran via SCCM need to be signed using your personal Certificate. Contact Brandon Ellenburg to request a certificate.

**SadPrint** - GUI for managing printers added via the PrintUI.

**Add-SharedPrinter** - Adds a shared printer using the built in PrintUI. Local machine is the default target, and print01 is the default print server. Both parameters can be overridden.

**Remove-SharedPrinter** - Removes a shared printer using the built in PrintUI. Local machine is the default target, and print01 is the default print server. Both parameters can be overridden.

**Get-SharedPrinter** - Returns a list of shared printers using the built in PrintUI. Local machine is the default target, but the parameter can be overridden.

**Test-ADObject** - Checks whether an AD object exists or not. The types of objects it currently can check for is limited. Check document for full list of objects.

**Rename-ADComputer** - Renames a computer and updates Active Directory. Local machine is the default target, but the parameter can be overridden.
