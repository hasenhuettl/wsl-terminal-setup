# ------------------------------------
# Collection of utility functions.
# ------------------------------------

# Custom standard library
# -----------------------
function CheckIsElevated {
	$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$p = New-Object System.Security.Principal.WindowsPrincipal($id)
	if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
		Write-Output $true
	} else {
		Write-Output $false
	}
 }

function Wait-For-Keypress([string] $message, [string]$color = "Yellow", [bool] $shouldExit=$FALSE) {
	Write-Host "$message" -ForegroundColor $color
	$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	if ($shouldExit) {
		exit
	}
}
