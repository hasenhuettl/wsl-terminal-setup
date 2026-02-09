# PowerShell

# Define parameters
param (
	$Step = "Install"
)

# Stop on error
$ErrorActionPreference = "Stop"

# -------------------------------------
# Imports
# -------------------------------------

# Root Path for WSL-Setup
$rootPath = $PSScriptRoot | split-path -parent | split-path -parent

# Convert Windows-style path to Linux-style path
$linuxStyleRootPath = $rootPath -replace '\\', '/' -creplace '^([A-Za-z]):', '/mnt/$1' | ForEach-Object { $_.ToLower() }

# Import functions
. $PSScriptRoot\Functions.ps1
. $PSScriptRoot\WSL_Functions.ps1
. (Join-Path $rootPath '\Config\config.ps1')

Clear-Any-Restart

# Check if the specific distribution is already installed
$distroInstalled = (wsl --list --quiet) -contains "$distribution"

$script = $myinvocation.MyCommand.Definition

if ($distroInstalled) {
	param($Step="Setup")
}

# Todo: Only run if WSL is not installed:
if (Should-Run-Step "Install") {

	Write-Host "Installing WSL distribution $distribution..."

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

	Write-Host "Installing Nerf Font..."
	# Define variables
	$downloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
	$destination = "$env:TEMP\JetBrainsMono.tar.xz"
	$extractPath = "$env:TEMP\JetBrainsMonoFonts"

	# Download the font zip
	Invoke-WebRequest -Uri $downloadUrl -OutFile $destination

	# Extract it
	Expand-7Zip -ArchiveFileName "$env:TEMP\JetBrainsMono.tar.xz" -TargetPath "$env:TEMP\JetBrainsMonoFonts"

	# Install fonts
	$fonts = Get-ChildItem -Path $extractPath -Include *.ttf -Recurse
	foreach ($font in $fonts) {
		Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts"
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
			-Name $font.BaseName -PropertyType String -Value $font.Name -Force | Out-Null
	}

	Write-Host "Nerd Font installed successfully!" -ForegroundColor Green

	# Edit Windows Terminal Settings:

	Write-Host "Copying Windows Terminal Settings..."

	# Get the current user's Windows Terminal settings path
	$terminalSettingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

	# Define your source settings file path (adjust this to your actual path)
	$sourceSettingsPath = "$env:USERPROFILE\git\wsl-terminal-setup-main\Install\WinTerminal\settings.json"

	Copy-Item $sourceSettingsPath $terminalSettingsPath -Force
	Write-Host "Successfully copied settings to Windows Terminal" -ForegroundColor Green

	# Set default profile to ubuntu guid
	# Change hotkeys for copy as well as insert

	# User setup
	Wait-For-Keypress "Please start $distribution, then set your windows username and some password.."

	bash "$linuxStyleRootPath/Install/WinTerminal/settings.json"
	#bash /mnt/c/Scripts/Bash/wsl_setup.sh
	# Ubuntu shell

	Write-Host "Running APT update and install..."
	bash "$linuxStyleRootPath/Install/Bash/wsl_setup.sh"
	#bash /mnt/c/Scripts/Bash/wsl_setup.sh

	Write-Host "Running Bash Scripts..."
	bash "$linuxStyleRootPath/Install/Bash/downloads.sh"
	#bash /mnt/c/Scripts/Bash/downloads.sh

	# Restart WSL
	wsl --shutdown

	# TODO: validate path
	# reg import .\URL_Handler.reg

	Write-Host "Resetting ExecutionPolicy back to Restricted..."
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force;

	Write-Host "Installation successfully finished!"

}

