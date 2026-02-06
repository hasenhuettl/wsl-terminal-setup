# PowerShell

# Parameter to prevent infinite recursion loop
param(
    [switch]$elevated = $false
)

. $PSScriptRoot\Install\PowerShell\Functions.ps1

$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
# Ensure ExecutionPolicy Policy is set to RemoteSigned
if ($executionPolicy -eq "Restricted") {
    Wait-For-Keypress -message "`nEnsure ExecutionPolicy Policy is set to RemoteSigned! Command:`n
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force`n`nPress any key to close..." -color "Red"
}

# Ensure this script is run as admin
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # Tried to elevate, did not work, aborting to prevent recursion loop
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-noprofile", "-file", $myinvocation.MyCommand.Definition, "-elevated"
    }
    exit
}

# Run installation functions, print error on fail
try {
    . $PSScriptRoot\Install\PowerShell\Install_WSL.ps1

} catch {
    $ErrorMessage = $_.Exception.Message

    Wait-For-Keypress -message "`n$ErrorMessage`n`nPress any key to close..." -color "Red"
    exit
}

Wait-For-Keypress -message "`nInstallation successful!`n`nPress any key to close..." -color "Green"

Write-Host "Resetting ExecutionPolicy back to Restricted..."
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force;
exit

# Known Issues:
# export TERM=xterm in case of problems
# _ssh, \ssh or ussh can be used instead of ssh to get back default ssh behavior
