param($Step="Install")
# -------------------------------------
# Imports
# -------------------------------------
. $PSScriptRoot\Functions.ps1
. $PSScriptRoot\WSL_Functions.ps1
. (Join-Path $PSScriptRoot '..\..\Config\config.ps1')

Clear-Any-Restart

if (Should-Run-Step "Install") {
	Write-Host "Installing WSL..."

	wsl --install --distribution $distribution

	Wait-For-Keypress "The script will continue after a reboot, press any key to reboot..."
	Restart-And-Resume $script "Setup"
}

if (Should-Run-Step "Setup") {
	Write-Host "Updating WSL..."
    wsl --update

	winget install Microsoft.WindowsTerminal

	# Start Menu: Start ubuntu
	# Use your windows username and some other password
	
	
	# Start Menu -> Launch Windows Terminal:
	
	# Edit Settings on top of windows terminal v Symbol
	
	# Set default profile to ubuntu guid
	# Change hotkeys for copy as well as insert
	
	
	# Ubuntu shell
	

	Write-Host "Running APT update and install..."
	# Call this as script initial_Install.sh with whoami as param!
	bash /mnt/c/Scripts/Bash/initial_Install.sh 

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


