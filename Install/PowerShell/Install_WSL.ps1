# PowerShell

# Define parameters
param (
	[string] $Step = "Install",
	[switch] $Elevated = $false
)

# Stop on error
$ErrorActionPreference = "Stop"

# Disable download bar as it slows down download speed ~10x
$ProgressPreference = 'SilentlyContinue'

trap {
	Write-Host "Error occurred: $_" -ForegroundColor Red
	Wait-For-Keypress "Press any key to cancel..."
	exit 1
}

# -------------------------------------
# Imports
# -------------------------------------

# Path to this script
$script = $myinvocation.MyCommand.Definition

# Root Path for WSL-Setup
$rootPath = $PSScriptRoot | split-path -parent | split-path -parent

# Import $distribution variable
. (Join-Path $rootPath '\Config\config.ps1')

# Convert Windows-style path to Linux-style path
$linuxStyleRootPath = $rootPath -replace '\\', '/' -creplace '^([A-Za-z]):', '/mnt/$1' | ForEach-Object { $_.ToLower() }

# Check if the specific distribution is already installed
$distroInstalled = (wsl --list --quiet) -contains "$distribution"

if ($distroInstalled) {
	$Step = "Setup"
}

# Import functions
. $PSScriptRoot\Functions.ps1
. $PSScriptRoot\WSL_Functions.ps1

# Ensure this script is run as admin
function Test-Admin {
	$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
	$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
	if ($Elevated) {
		# Tried to elevate, did not work, aborting to prevent recursion loop
	} else {
		Start-Process powershell.exe `
			-Verb RunAs `
			-ArgumentList "-noprofile", `
			"-file", $myinvocation.MyCommand.Definition, `
			"-Step", "$Step", `
			"-Elevated"
	}
	exit
}

Clear-Any-Restart

Write-Host "$Step"
# Todo: Only run if WSL is not installed:
if (Should-Run-Step "Install") {
	Write-Host "Installing WSL distribution $distribution..."
	Write-Host "If you are asked to setup user + password, please enter 'exit' afterwards." -ForegroundColor Magenta

	wsl --install --distribution "$distribution"

	Wait-For-Keypress "The script will continue after a reboot, press any key to reboot..."
	Restart-And-Resume $script "Setup"
}

if (Should-Run-Step "Setup") {
	Write-Host "Updating WSL..."
	wsl --update

	Write-Host "Installing Windows Terminal..."
	winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements

	Write-Host "Installing 7zip for PowerShell..."
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Install-Module -Name 7Zip4Powershell -Scope CurrentUser -Force

	# Define variables
	$downloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
	$destination = "$env:TEMP\JetBrainsMono.tar.xz"
	$extractPath = "$env:TEMP\JetBrainsMonoFonts"
	$tarPath = Join-Path $extractPath "JetBrainsMono.tar"

	# Download the font zip
	Write-Host "Downloading Nerd Font..."
	Invoke-WebRequest -Uri $downloadUrl -OutFile $destination

	# Extract it
	Write-Host "Extracting Nerd Font..."
	Expand-7Zip -ArchiveFileName "$destination" -TargetPath "$extractPath"

	# Sanity check if 7zip expanded .tar.gz to .tar
	if (Test-Path $tarPath) {
		Expand-7Zip -ArchiveFileName $tarPath -TargetPath $extractPath
		Remove-Item $tarPath -Force
	}

	# Install fonts
	Write-Host "Installing Nerd Font..."
	$fonts = Get-ChildItem -Path $extractPath -Include *.ttf -Recurse
	foreach ($font in $fonts) {
		Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts"
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
			-Name $font.BaseName -PropertyType String -Value $font.Name -Force | Out-Null
	}

	Write-Host "Nerd Font installed successfully!" -ForegroundColor Green

	# Edit Windows Terminal Settings:

	# Define paths
	$terminalSettingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
	$sourceSettingsPath = "$env:USERPROFILE\git\wsl-terminal-setup-main\Install\WinTerminal\settings.json"

	# Step 1: Read json data from the DESTINATION (current/live) settings BEFORE overwriting
	$preservedDefault = $null
	$preservedProfiles = $null
	if (Test-Path $terminalSettingsPath) {
		Write-Host "Reading existing data from current Terminal settings..."
		$existingSettings = Get-Content $terminalSettingsPath -Raw | ConvertFrom-Json
		$preservedDefault = $existingSettings.defaultProfile
		$preservedProfiles = $existingSettings.profiles.list
		Write-Host "Found $($preservedProfiles.Count) existing profile(s) to preserve." -ForegroundColor Cyan
	}

	# Step 2: Copy the source settings file over the destination
	Copy-Item $sourceSettingsPath $terminalSettingsPath -Force
	Write-Host "Copied base settings to Windows Terminal." -ForegroundColor Green

	# Step 3: Re-apply preserved data via targeted raw text replacement
	if ($null -ne $preservedProfiles) {
		Write-Host "Restoring json data into new settings..."
		$rawJson = Get-Content $terminalSettingsPath -Raw

		# Replace defaultProfile value (handles any existing guid or empty string)
		$rawJson = $rawJson -replace '("defaultProfile"\s*:\s*)"[^"]*"', "`$1`"$preservedDefault`""

		# Serialize profiles list and replace the list array
		$profilesJson = $preservedProfiles | ConvertTo-Json -Depth 20
		# Ensure it's an array even for a single profile
		if ($preservedProfiles.Count -eq 1) { $profilesJson = "[ $profilesJson ]" }
		# Replace the entire list array (from [ to matching ])
		$rawJson = $rawJson -replace '("list"\s*:\s*)\[[\s\S]*?\]', "`$1$profilesJson"

		Set-Content $terminalSettingsPath -Value $rawJson -Encoding UTF8 -NoNewline
		Write-Host "Successfully restored $($preservedProfiles.Count) profile(s)." -ForegroundColor Green
	} else {
		Write-Host "No Profiles found!" -ForegroundColor Red
	}

	# Change hotkeys for copy as well as insert

	# User setup
	Write-Host "Please follow the following steps (if not already done previously):" -ForegroundColor Magenta
	Write-Host "  1) Open $distribution" -ForegroundColor Magenta
	Write-Host "  2) Define your WSL username and password" -ForegroundColor Magenta
	Write-Host "  3) Exit $distribution" -ForegroundColor Magenta
	Write-Host "  4) Return to this window" -ForegroundColor Magenta
	Wait-For-Keypress "If above steps are completed, press any button to continue..."

	# Set default wsl distro
	wsl --set-default $distribution

	# Ubuntu shell
	Write-Host "Running APT update and install..."
	bash "$linuxStyleRootPath/Install/Bash/wsl_setup.sh"

	Write-Host "Installing packages..."
	bash "$linuxStyleRootPath/Install/Bash/install_packages.sh"

	Write-Host "Placing config files..."
	bash "$linuxStyleRootPath/Install/Bash/userconfig_setup.sh"

	# Restart WSL
	wsl --shutdown

	# Import SSH URL Handling registry settings
	reg import "$env:USERPROFILE\git\wsl-terminal-setup-main\Install\Registry\URL_Handler.reg"

	Write-Host "Resetting ExecutionPolicy back to Restricted..."
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force;

	Write-Host "`nInstallation successfully finished!`n" -ForegroundColor Green
	Wait-For-Keypress -message "`Press any key to close installer and open Windows Terminal..." -color "Magenta"
	wt.exe
}
