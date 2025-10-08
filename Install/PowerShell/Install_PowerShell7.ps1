# Install PowerShell
winget install --id Microsoft.PowerShell --source winget

# Set PowerShell profile

# Define profile path
$profilePath = $PROFILE

# Create profile file if it doesn't exist
if (-not (Test-Path $profilePath)) {
  New-Item -Path $profilePath -ItemType File -Force | Out-Null
}

# Read existing content
$content = Get-Content $profilePath -Raw

# Add Vi mode if missing
if (-not ($content -like '*Set-PSReadlineOption -EditMode Vi*')) {
    Add-Content $profilePath "`nSet-PSReadlineOption -EditMode Vi"
    Write-Host "➕ Added: Set-PSReadlineOption -EditMode Vi"
}

# Add VirtualBox path if missing
if (-not ($content -like '*C:\Program Files\Oracle\VirtualBox*')) {
    Add-Content $profilePath "`n`$env:Path += ';C:\Program Files\Oracle\VirtualBox'"
    Write-Host "➕ Added: VBoxManage path"
}

Write-Host "✅ PowerShell profile updated at: $profilePath"

