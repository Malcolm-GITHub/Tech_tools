# Define the GitHub raw content URL for the 'libs' directory
$repoURL = "https://github.com/YourUsername/MyPowerShellScripts/archive/refs/heads/main.zip"
$downloadPath = "$env:TEMP\MyPowerShellScripts.zip"
$extractPath = "$env:TEMP\MyPowerShellScripts-main\libs"
$destPath = "C:\Tech_Folder\Libs"

# Download the ZIP archive of the repository
Write-Host "Downloading repository from GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $repoURL -OutFile $downloadPath -ErrorAction Stop

# Extract the ZIP file
Write-Host "Extracting repository..." -ForegroundColor Cyan
Expand-Archive -Path $downloadPath -DestinationPath $env:TEMP -Force

# Ensure destination exists
if (-not (Test-Path $destPath)) {
    New-Item -Path $destPath -ItemType Directory
}

# Check if extracted 'libs' directory exists
if (Test-Path $extractPath) {
    # Copy files from 'libs' to destination
    Write-Host "Copying libraries to $destPath..." -ForegroundColor Cyan
    Copy-Item -Path "$extractPath\*" -Destination $destPath -Recurse -Force
    Write-Host "Libraries copied successfully to $destPath" -ForegroundColor Green
} else {
    Write-Host "Error: 'libs' directory not found in the extracted repository." -ForegroundColor Red
}

# Cleanup
Remove-Item -Path $downloadPath -Force
Remove-Item -Path "$env:TEMP\MyPowerShellScripts-main" -Recurse -Force

Start-Sleep 3
