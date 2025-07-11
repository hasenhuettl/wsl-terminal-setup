﻿param($Step="Install")
# -------------------------------------
# Imports
# -------------------------------------

# Root Path for WSL-Setup
$rootPath = $PSScriptRoot | split-path -parent | split-path -parent

# Convert Windows-style path to Linux-style path
$linuxStyleRootPath = $rootPath -replace '\\', '/' -creplace '^([A-Za-z]):', '/mnt/$1' | ForEach-Object { $_.ToLower() }

# Bash script paths
$wsl_setup_script = "$linuxStyleRootPath/Install/Bash/wsl_setup.sh"

# Import functions
. $PSScriptRoot\Functions.ps1
. $PSScriptRoot\WSL_Functions.ps1
. (Join-Path $rootPath '\Config\config.ps1')

bash $wsl_setup_script
exit

Clear-Any-Restart

# Todo: Only run if WSL is not installed:
if (Should-Run-Step "Install") {
	Write-Host "Installing WSL..."

	wsl --install --distribution "$distribution"

	Wait-For-Keypress "The script will continue after a reboot, press any key to reboot..."
	Restart-And-Resume $script "Setup"
}

if (Should-Run-Step "Setup") {
	Write-Host "Updating WSL..."
	wsl --update

	winget install Microsoft.WindowsTerminal

	# Define variables
	$downloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
	$destination = "$env:TEMP\JetBrainsMono.zip"
	$extractPath = "$env:TEMP\JetBrainsMonoFonts"

	# Download the font zip
	Invoke-WebRequest -Uri $downloadUrl -OutFile $destination

	# Extract it
	Expand-Archive -Path $destination -DestinationPath $extractPath -Force

	# Install fonts
	$fonts = Get-ChildItem -Path $extractPath -Include *.ttf -Recurse
	foreach ($font in $fonts) {
		Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts"
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
			-Name $font.BaseName -PropertyType String -Value $font.Name -Force | Out-Null
	}

	Write-Host "JetBrainsMono Nerd Font installed successfully!"

	# Start Menu -> Launch Windows Terminal:

	# Edit Settings on top of windows terminal v Symbol:
	# TODO: import windows Terminal settings.json automatically
	# Set default profile to ubuntu guid
	# Change hotkeys for copy as well as insert


	# Start Menu: Start ubuntu
	# Use your windows username and some other password


	# Ubuntu shell

	Write-Host "Running APT update and install..."
	# Call this as script wsl_setup.sh with whoami as param!
	bash /mnt/c/Scripts/Bash/wsl_setup.sh

	Write-Host "Running Bash Scripts..."
	# Call this as script downloads.sh

	# Restart WSL
	wsl --shutdown

	# TODO: validate path
	reg import .\URL_Handler.reg

	# Installation successfully finished!

}

if (Should-Run-Step "C") {
	Write-Host "Option C..."
}


