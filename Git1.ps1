
$repoURL = "https://github.com/Malcolm-GITHub/Tech_tools/releases/download/TweakerTag/Libs.zip"
$downloadPath = "$env:TEMP\Libs.zip"
$extractPath = "$env:TEMP\ExtractedLibs"
$destPath = "C:\Tech_Folder\Libs"

# Download the ZIP archive from GitHub
Write-Host "Downloading repository from GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $repoURL -OutFile $downloadPath -ErrorAction Stop

# Extract the ZIP file
Write-Host "Extracting repository..." -ForegroundColor Cyan
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Ensure destination exists
if (-not (Test-Path $destPath -ErrorAction Stop)) {
    New-Item -Path $destPath -ItemType Directory -Force | Out-Null
}

# Find the extracted 'libs' directory
$libsExtractedPath = Join-Path -Path $extractPath -ChildPath "libs"
if (Test-Path $libsExtractedPath) {
    # Copy extracted libraries to destination
    Write-Host "Copying libraries to $destPath..." -ForegroundColor Cyan
    Copy-Item -Path "$libsExtractedPath\*" -Destination $destPath -Recurse -Force
    Write-Host "✅ Libraries copied successfully to $destPath" -ForegroundColor Green
} else {
    Write-Host "❌ Error: 'libs' directory not found in the extracted ZIP." -ForegroundColor Red
}

# Cleanup temporary files
Write-Host "Cleaning up temporary files..." -ForegroundColor Cyan
Remove-Item -Path $downloadPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "✅ Script completed successfully." -ForegroundColor Green
Start-Sleep 3


# First launch Animation
Clear

$lines = @(
    "        AAAAAAAA    IIIIIIIIIIIIIIIIIIIIIIIIIITTTTTTTTTTTTTTTTTTTTTTTTTT ",
    "      AAAAAAAAAAAA  IIIIII::::::::::::::IIIIIITT::::::::::::::::::::::TT ",
    "     AAAAAA  AAAAAA IIIIII::::::::::::::IIIIIITT::::::::::::::::::::::TT ",
    "    AAAAAA    AAAAAAIIIIIIIIIII::::IIIIIIIIIIITT:::::TT:::::::TT::::::TT ",
    "   AAAAAA      AAAAAA       III::::III         TTTTTT  T:::::T  TTTTTT   ",
    "   AAAAA        AAAAA       III::::III                 T:::::T           ",
    "   AAAAA        AAAAA       III::::III                 T:::::T           ",
    "   AAAAA  AAAA  AAAAA       III::::III                 T:::::T           ",
    "   AAAAA AAAAAA AAAAA       III::::III                 T:::::T           ",
    "   AAAAA  AAAA  AAAAA       III::::III                 T:::::T           ",
    "   AAAAA        AAAAA       III::::III                 T:::::T           ",
    "   AAAAA        AAAAA       III::::III                 T:::::T           ",
    "   AAAAAA      AAAAAA       III::::III                 T:::::T           ",
    "   AAAAAA      AAAAAAA IIIIIIII::::IIIIIIIII      TTT:::::::::::TTT        ",
    " AAAAAAAAAA  AAAAAAAAAIIII::::::::::::::IIIII   TTTTT:::::::::::TTTTT      ",
    " AAAAAAAAAA  AAAAAAAAAIIIIIIIIIIIIIIIIIIIIIII   TTTTTTTTTTTTTTTTTTTTT      ",
    "",
    "",
    "====================== Malcolm Marcus - Tech =====================",
    "===================                            ===================",
    "================= Windows Tweak & Squeak Toolbox =================",
    "===============                                   ================",
    "============= Powered by Advanced IT, Scottburgh KZN =============",

    "",
    "April 2024 Edition"
)

foreach ($line in $lines) {
    Write-Output $line
    Start-Sleep -Milliseconds 75
}

Write-host "This script will harden your system and tweak it for maximum performance."
Write-Host "You may run this script at any time should you feel things may have changed"
Write-Host "You may also call the script from GitHub, using..." -ForegroundColor Green
Write-Host ""
Write-Host "Invoke-RestMethod https://tinyurl.com/trixit | Invoke-Expression"
Start-Sleep 4

# Start Progress indicator

# Initialize progress bar
$steps = 42
$step = 0

function Update-Progress {
    param (
        [int]$PercentComplete
    )
    Write-Progress -Activity "System Tweaking" -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete
}

# Helper function to update progress bar
function Step-Progress {
    $global:step++
    $percentComplete = [math]::Round(($global:step / $global:steps) * 100)
    Update-Progress -PercentComplete $percentComplete
    Start-Sleep -Seconds 1
}

# Step 1 -Check the operating system type#########################################################################################
Step-Progress

if ([Environment]::Is64BitOperatingSystem) {
Write-Host "64-Bit Operating System detected." -ForegroundColor Cyan
} else {
Write-Host "32-Bit Operating System detected." -ForegroundColor Cyan
}

# Check the Operating system build
$osVersion = [Environment]::OSVersion.Version
$osBuild = $osVersion.Build
Write-Host "Operating System Build: $osBuild"

#Check the PowerShell version
$psVersion = $PSVersionTable.PSVersion
Write-Host "PowerShell Version: $($psVersion.Major).$($psVersion.Minor)"
Write-Host ""
Write-Host ""
Write-Host "Continuing with performance tweak operations...." -ForegroundColor Yellow

###############Clean up to here 170225

# Step 2 -Disable Wifi-Hotspot #######################################################################################################
Step-Progress

Write-Host "Disabling Wifi Hotspot reporting and AutoConnect to Wifisense Hotspots" -ForegroundColor Yellow

# Check if AllowWiFiHotSpotReporting key exists, if not, create it
if (-not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}

# Set Value to 0 under AllowWiFiHotSpotReporting
Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Value 0 -ErrorAction SilentlyContinue

# Set Value to 0 under AllowAutoConnectToWiFiSenseHotspots
Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Value 0 -ErrorAction SilentlyContinue

Write-Output "Wifi Hotspot reporting & Connections to WifiSenseHotspots disabled."
Write-Host "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting set to 0" -ForegroundColor Green
Write-Host "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots set to 0" -ForegroundColor Green

start-sleep 2

#Step 3 -Enable Long File Names, Rebuild Icon Cache, Rebuild Thumbnail Cache################################################################################################
Step-Progress

Write-Host "Setting Registry to allow Long File Name Conventions" -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -NAME "LongPathsEnabled" -Value 1 -ErrorAction SilentlyContinue
Write-Host "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem LongPathsEnabled set to 1" -ForegroundColor Green

# Rebuild Icon Cache
Write-Host "Rebuilding Windows 10 and Windows 11 -Icon Cache..." -ForegroundColor Yellow

$iconCachePath = "$env:SystemRoot\system32\ie4uinit.exe"
$iconCacheArguments = "-show"
$iconCacheProcess = Start-Process -FilePath $iconCachePath -ArgumentList $iconCacheArguments -NoNewWindow -PassThru -ErrorAction SilentlyContinue
$iconCacheProcess.WaitForExit()

Write-Host "Icon Cache Rebuilt." -ForegroundColor Green
Start-Sleep -Seconds 3

# Rebuild Thumbnail Cache
Write-Host "Rebuilding Thumbnail Cache..." -ForegroundColor Green

$thumbnailCachePath = "cmd.exe"
$thumbnailCacheArguments = "/c, del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db"
$thumbnailCacheProcess = Start-Process -FilePath $thumbnailCachePath -ArgumentList $thumbnailCacheArguments -NoNewWindow -PassThru -ErrorAction SilentlyContinue
$thumbnailCacheProcess.WaitForExit()

Write-Host "Thumbnail Cache Rebuilt." -ForegroundColor Green
Start-Sleep -Seconds 2

# Step 4 -Disable UserActivity###################################################################################################
Step-Progress

Write-Host "Disabling UserActivity" -ForegroundColor Green

# Open the registry key
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Check if the registry key exists, if not, create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
$Name1 = "EnableActivityFeeds"
$Name2 = "PublishUserActivities"
$Name3 = "UploadUserActivities"

# Set the registry values
#"EnableActivityFeed"
#"PublishUserActivities"
#"UploadUserActivities"

Set-ItemProperty -Path $registryPath -Name $Name1 -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name2 -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name3 -Value 0 -Type DWord -ErrorAction SilentlyContinue

# Write-Output "$Name1, Set to Disabled","$Name2, Set to Disabled","$Name3, Set to Disabled"
Write-Host "$Name1, Set to Disabled", "$Name2, Set to Disabled", "$Name3, Set to Disabled" -ForegroundColor Yellow

# Step 5 -Location and privacy settings########################################################################################
Step-Progress

Write-Host "Setting ConsentPromptBehaviourAdmin to 0 under System" -ForegroundColor Green
# Set ConsentPromptBehaviorAdmin to 0 under Policies\System
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -ErrorAction SilentlyContinue

Write-Output "ConsentPromptBehaviorAdmin set to 0 successfully."

Write-Host "Disabling Location Tracking services -- Bill Gates sucks" -ForegroundColor Cyan

Start-Sleep -Seconds 2

# Set registry value to Deny under CapabilityAccessManager\ConsentStore\location
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -ErrorAction SilentlyContinue

# Set SensorPermissionState to 0 under Sensor\Overrides
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value 0 -ErrorAction SilentlyContinue

# Set Status to 0 under lfsvc\Service\Configuration
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Value 0 -ErrorAction SilentlyContinue

# Set AutoUpdateEnabled to 0 under SYSTEM\Maps
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Value 0 -ErrorAction SilentlyContinue

Write-Host "Registry settings updated successfully. Consent Store location disabled, Sensor Overides enabled, Map updates disabled except Manual" -ForegroundColor Yellow

# Step 6 -Disable adverts#######################################################################################################
Step-Progress

Write-Host "Disabling adverts from Amazon.com main hub advertisering authority" -ForegroundColor Red

$adlist = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host' -ErrorAction SilentlyContinue
$adfile = "$env:windir\System32\drivers\etc\hosts"
$adlist | Add-Content -PassThru $adfile -ErrorAction SilentlyContinue

Write-Host "https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host  -- Added to database" -ForegroundColor Yellow
start-sleep 2

#Enable game mode, disable unneeded

   start-sleep 2

# Define the registry paths and values
$registryPaths = @{
    "HKCU:\System\GameConfigStore" = @{
        "GameDVR_FSEBehavior" = 2
        "GameDVR_Enabled" = 0
        "GameDVR_DXGIHonorFSEWindowsCompatible" = 1
        "GameDVR_HonorUserFSEBehaviorMode" = 1
        "GameDVR_EFSEFeatureFlags" = 0
    }
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" = @{
        "AllowGameDVR" = 0
    }
}

# Iterate over each registry path
foreach ($registryPath in $registryPaths.Keys) {
    # Check if the registry path exists, if not, create it
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    # Iterate over each value in the current registry path
    foreach ($value in $registryPaths[$registryPath].Keys) {
        # Check if the value is already set, if not, set it
        if ((Get-ItemProperty -Path $registryPath -Name $value -ErrorAction SilentlyContinue) -eq $null) {
            Set-ItemProperty -Path $registryPath -Name $value -Value $registryPaths[$registryPath][$value] -Type DWord -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "Game DVR Policies, Set to disabled" -ForegroundColor Green
start-sleep 2

# Step 7 -Disable hibernation ###################################################################################################
Step-Progress

$response = Read-Host "Do you want to enable Hibernation ? (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
Write-Host "Enabling now and removing the option to edit from Explorer" -ForegroundColor Red


Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Value 1 -ErrorAction SilentlyContinue

# Create registry key if not exists
if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Force | Out-Null
}

# Hide hibernate option in Windows Explorer
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Value 0 -ErrorAction SilentlyContinue

Write-Host "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings set to 0" -ForegroundColor Green
Write-Host "HKLM:\System\CurrentControlSet\Control\Session Manager\Power Hibernate enabled and edit function removed from Explorer" -ForegroundColor Green


} elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Disabling Hibernation and removing the option to edit from Explorer" -ForegroundColor Yellow
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Value 0 -ErrorAction SilentlyContinue

# Create registry key if not exists
if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Force | Out-Null
}

# Hide hibernate option in Windows Explorer
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Value 0 -ErrorAction SilentlyContinue

Write-Host "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings set to 0" -ForegroundColor Green
Write-Host "HKLM:\System\CurrentControlSet\Control\Session Manager\Power Hibernate Disabled and option to edit function removed from Explorer" -ForegroundColor Green

   }

# Step 8 -Disable HomeGroup-related services if they exist#######################################################################

$listenerService = Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue
if ($listenerService -ne $null) {
    Set-Service -Name HomeGroupListener -StartupType Manual
    Write-Output "Service 'HomeGroupListener' set to Manual startup type."
} else {
    Write-Output "Service 'HomeGroupListener' not found. Skipping..."
}

$providerService = Get-Service -Name HomeGroupProvider -ErrorAction SilentlyContinue
if ($providerService -ne $null) {
    Set-Service -Name HomeGroupProvider -StartupType Manual
    Write-Output "Service 'HomeGroupProvider,' set to Manual startup type."
} else {
    Write-Output "Service 'HomeGroupProvider' not found. Skipping..."
}

Write-Host "Homegroup Disabled and set to startup type manual" -ForegroundColor Green

# Step 9 -Disable Application Compatibility ###################################################################################################
Step-Progress

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Setting Group Policy Settings to 'disabled' for Application Compatibility in the registry to speed up Windows" -ForegroundColor Green
Write-Host ""
Write-Host ""

# Open the registry key
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"

# Check if the registry key exists, if not, create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
$Name1 = "VDMDisallowed"
$Name2 = "DisablePropPage"
$Name3 = "AITEnable"
$Name4 = "DisableEngine"
$Name5 = "DisablePCA"
$Name6 = "DisableInventory"
$Name7 = "SbEnable"
$Name8 = "DisableUAR"

# Set the registry values
#"VDMDisallowed"
#"DisablePropPage"
#"AITEnable"
#"DisableEngine"
#"DisablePCA"
#"DisableInventory"
#"SbEnable"
#"DisableUAR"

Set-ItemProperty -Path $registryPath -Name $Name1 -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name2 -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name3 -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name4 -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name5 -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name6 -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name7 -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $registryPath -Name $Name8 -Value 1 -Type DWord -ErrorAction SilentlyContinue

# Write-Output "$Name1, Set to Disabled","$Name2, Set to Disabled","$Name3, Set to Disabled"
Write-Host "The following settings are found in the Group Policy Editor //Computer Config/Administrative Templates/Windows Components/Application Compatability" -ForeGroundColor Cyan
Write-Host "Group Policy Objects are written to the registry in a single direction, changes made here will not reflect in the GPO" -ForeGroundColor Cyan
Write-Host "The Script will automatically check for the existence of these settings in the registry and modify them as needed :-)" -ForeGroundColor Cyan

Sleep 3
Write-Host "Prevent access to 16-bit applications" -ForeGroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name1 - Set to Enabled" -ForegroundColor Yellow

Write-Host "Remove Program Compatibility Property Page" -ForegroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name2 - Set to Enabled" -ForegroundColor Yellow

Write-Host "Turn Off Application Telemetry" -ForeGroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name3 - Set to Disabled -This enables it !" -ForegroundColor Yellow

Write-Host "Turn off Application Compatibility Engine" -ForeGroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name4 - Set to Enabled" -ForegroundColor Yellow

Write-Host "Turn off Program Compatibility Assistant" -ForeGroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name5 - Set to Enabled" -ForegroundColor Yellow

Write-Host "Turn off Inventory Collector - Sorry Microsoft, get lost !" -ForegroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name6 - Set to Enabled" -ForegroundColor Yellow

Write-Host "Turn off SwitchBack Compatibility Engine" -ForeGroundColor White
Write-Host "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name7 - Set to Disabled" -ForegroundColor White

Write-Host "Turn off Steps Recorder"
Write-Host " The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name8 - Set to Enabled" -ForegroundColor Yellow

Start-Sleep 4



# Step 10 -Get the list of language resource files###############################################################################
Step-Progress

$LangList = Get-WinUserLanguageList

Write-host "$LangList" -ForegroundColor Gray
#Filter out English language resourceSet files
$EnglishLang = $LangList | where { $_.LanguageTag -eq "en-US" }

# Create a new List to keep only the English Language
$LangListToKeep = @($EnglishLang)

# Set the user Language list to English only
Set-WinUserLanguageList -LanguageList $LangListToKeep -Force -ErrorAction SilentlyContinue

Write-host "The $EnglishLang language list has been kept as default" -ForegroundColor Green

Start-Sleep -Seconds 2

# Step 11 -Display performance mode##############################################################################################
Step-Progress

Write-Host "Setting display for performance mode" -ForegroundColor Yellow

# Set DragFullWindows to 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value 0 -ErrorAction SilentlyContinue

# Set MenuShowDelay to 200
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 200 -ErrorAction SilentlyContinue

# Set MinAnimate to 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -ErrorAction SilentlyContinue

# Set KeyboardDelay to 0
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0 -ErrorAction SilentlyContinue

# Set ListviewAlphaSelect to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0 -ErrorAction SilentlyContinue

# Set ListviewShadow to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0 -ErrorAction SilentlyContinue

# Set TaskbarAnimations to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -ErrorAction SilentlyContinue

# Set VisualFXSetting to 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 3 -ErrorAction SilentlyContinue

# Set EnableAeroPeek to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Value 0 -ErrorAction SilentlyContinue

# Set TaskbarMn to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -ErrorAction SilentlyContinue

# Set TaskbarDa to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -ErrorAction SilentlyContinue

# Set ShowTaskViewButton to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -ErrorAction SilentlyContinue

# Set SearchboxTaskbarMode to 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -ErrorAction SilentlyContinue

############################################# ADD 2ND STEP (13) ######################################################################
Step-Progress

Write-Host "Display Performance Profiling, enabled." -ForegroundColor Yellow
Write-host "The following display performance metrics have been tweaked on your system"
Write-host ""
Write-Host "The following display related tweaks are now set :" -ForeGroundColor Yellow
Write-Host "HKCU:\Control Panel\Desktop -Name DragFullWindows -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Control Panel\Desktop -Name MenuShowDelay -Value set to 200ms" --ForeGroundColor White
Write-Host "HKCU:\Control Panel\Desktop\WindowMetrics -Name MinAnimate -Value set to 0" -ForeGroundColor White
Write-host "HKCU:\Control Panel\Keyboard -Name KeyboardDelay -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ListviewAlphaSelect -Value set to 0" -ForeGroundColor White
Write-host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ListviewShadow -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAnimations -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects -Name VisualFXSetting -Value set to 3" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\DWM -Name EnableAeroPeek -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value set to 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0" -ForeGroundColor White
Write-Host "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value set to 0" -ForeGroundColor White

Start-Sleep 2

# Step 12 -Install Chocolatey####################################################################################################

Step-Progress

#Set-ExecutionPolicy Unrestricted -ErrorAction SilentlyContinue
#Set-ExecutionPolicy AllSigned -ErrorAction SilentlyContinue
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -ErrorAction SilentlyContinue

Write-Host "Choco Installed Mate !!" -ForegroundColor Green

# Step 13 -Install Winget########################################################################################################
Step-Progress

Write-host "Installing Winget and NuGet package providers ..." -ForeGroundColour Yellow
Write-host "Invoke with >winget search name or >winget install name ..from command prompt to install software from the net" -ForegroundColor Cyan
start-sleep 2

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue
Install-Module -Name Microsoft.WinGet.Client -ErrorAction SilentlyContinue

start-sleep 1
# Step 14 -Reset Network#########################################################################################################
Step-Progress

Write-Host "Resetting Network with netsh" -ForegroundColor Red

# Reset WinSock catalog to a clean state
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "winsock", "reset" -ErrorAction SilentlyContinue
# Resets WinHTTP proxy setting to DIRECT
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "winhttp", "reset", "proxy" -ErrorAction SilentlyContinue
# Removes all user configured IP settings
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "int", "ip", "reset" -ErrorAction SilentlyContinue

Write-Host "netsh -ArgumentList --winsock, Reset WinSock catalog to a clean state completed" -ForegroundColor White
Write-Host "netsh -ArgumentList --winhttp, reset WinHTTP proxy setting to DIRECT completed" -ForegroundColor White
Write-Host "netsh -ArgumentList --int, ip, Remove all user configured IP settings completed" -ForegroundColor White

Write-Host "Process complete. Please reboot your computer." -ForegroundColor Green
Start-Sleep 8

#################################################################################################################################
# Step 15 - Disable teredo tunneling in Ipv6 (creates latency)- speed up network 

Step-Progress

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
$response = Read-Host "Do you want to disable Teredo Tunneling now ? (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "Disabling Teredo Tunneling..." -ForegroundColor Yellow

    # Main script
# Check if the registry key exists, if not, create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
$Name1 = "DisabledComponents"

Set-ItemProperty -Path $registryPath -Name $Name1 -Value 1 -Type DWord -ErrorAction SilentlyContinue

netsh interface teredo set state disabled
Write-Host "netsh interface teredo set state disabled" -ForegroundColor White

} elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Continuing with script block" -ForegroundColor Yellow
   }

# Step 16 -Disk Cleanup and old updates##########################################################################################

Step-Progress

Write-Host "Initiating disk cleanup operation" -ForegroundColor Yellow

# Run Disk Cleanup utility to clean up temp files and old updates
#Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sageset:1 /d C: /sDC" -NoNewWindow -Wait -ErrorAction SilentlyContinue
#Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait -ErrorAction SilentlyContinue

# Clear the Recycle Bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# Clean temp files and folders
Remove-Item -Path "C:\Windows\Temp\*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "%appdata%\Local\Temp\*" -Force -ErrorAction SilentlyContinue

# Compact the registry
Start-Process -FilePath "reg.exe" -ArgumentList "compact hiv" -NoNewWindow -Wait -ErrorAction SilentlyContinue

# Clean up Windows Update files
$UpdateLogPath = "C:\Windows\Logs\WindowsUpdate\"
$TempLogPath = "$env:TEMP\WindowsUpdateLog\"

# Check if the directory exists before attempting to remove files
if (Test-Path -Path $UpdateLogPath) {
    Remove-Item -Path $UpdateLogPath\* -Force -ErrorAction SilentlyContinue
}
else {
    Write-Warning "The directory '$UpdateLogPath' does not exist."
}

# Check if the directory exists before attempting to remove files
if (Test-Path -Path $TempLogPath) {
    $WindowsUpdateLogFile = Get-ChildItem -Path $TempLogPath -Filter "wuetl.log.tmp*" | Select-Object -First 1
    if ($WindowsUpdateLogFile) {
        $LogPath = Join-Path -Path $UpdateLogPath -ChildPath $WindowsUpdateLogFile.Name
        Copy-Item -Path $WindowsUpdateLogFile.FullName -Destination $LogPath -ErrorAction Stop
    }
    else {
        Write-Warning "No Windows Update log file found in '$TempLogPath'."
    }
}
else {
    Write-Warning "The directory '$TempLogPath' does not exist."
}

# Step 18 -GPEdit enable ########################################################################################################

Step-Progress

Write-host "We have finished the performance profiling and enhancements : )" -ForegroundColor White
Write-Host "Now lets do some Explorer tweaking, to pep the system environment for you.." -ForegroundColor Yellow

Start-Sleep 2

Write-Host "Inspecting Group Policy Environment on $osVersion.Build ..." -ForegroundColor Red
# cmd equivalent FOR %F IN ("%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~*.mum") DO (DISM /Online /NoRestart /Add-Package:"%F")
# cmd equivalent FOR %F IN ("%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~*.mum") DO (DISM /Online /NoRestart /Add-Package:"%F")

# Check if gpedit.msc exists
if (Test-Path "$env:SystemRoot\System32\gpedit.msc") {
    Write-Host "Group Policy Editor is enabled on this system." -ForeGroundColor Green
} 

else {
    Write-Host "Group Policy Editor is not enabled on this system." -ForeGroundColor Red
   # Prompt the user for input

   }

$response = Read-Host "Do you want to install GPEdit.msc now? (Y/N)"

# Check the response
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "Installing GPEdit.msc group policy editor..."
# Install Microsoft-Windows-GroupPolicy-ClientTools-Package
Get-ChildItem "$env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~*.mum" | ForEach-Object {
    DISM /Online /NoRestart /Add-Package:"$($_.FullName)"
}

# Install Microsoft-Windows-GroupPolicy-ClientExtensions-Package
Get-ChildItem "$env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~*.mum" | ForEach-Object {
    DISM /Online /NoRestart /Add-Package:"$($_.FullName)"
}

} elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Continuing with script block" -ForegroundColor Yellow
   }

# Step 19 Add powershell to Windows X Menu
Step-Progress

   # Add Powershell on Windows X Menu
# $response = Read-Host "Do you want to add Powershell (Admin) to the Windows X Menu now? (Y/N)"

# Check the response
# From here ADD or REMOVE Y or N REQUIREMENTS as needed...
# if ($response -eq "Y" -or $response -eq "y") {
    Write-host "Setting Powershell on the Windows X Menu now..." -ForegroundColor Yellow

    # Add registry value
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Value 0 -PropertyType DWORD -Force

    # Kill explorer.exe process
    Stop-Process -Name "explorer" -Force

    # Start explorer.exe
    Start-Process explorer.exe
# }
# elseif ($response -eq "N" -or $response -eq "n") {
        Write-Host "Continuing with next script block." -ForegroundColor Yellow
#   }

# Step 20 -Add Command on Windows Right click context menu##############################################################

Step-Progress

# $response = Read-Host "Do you want to add Command (Admin) to the Windows Right Click Context Menu? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    Write-host "Setting Command as Admin on the Windows Right Click Context Menu now..." -ForegroundColor Yellow
# Create registry keys for adding "Right click open as Command Admin" context menu

# Path to the registry key
$regPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2"
$regCommandPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2\command"

# Create registry keys and values
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "(Default)" -Value "@shell32.dll,-8506" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Extended" -Value $null -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Icon" -Value "imageres.dll,-5323" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "NoWorkingDirectory" -Value $null -PropertyType String -Force | Out-Null

New-Item -Path $regCommandPath -Force | Out-Null
New-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "cmd.exe /s /k pushd '%V'" -PropertyType String -Force | Out-Null
# }
# elseif ($response -eq "N" -or $response -eq "n") {
        Write-Host "Continuing with next script block." -ForegroundColor Yellow
#   }
   write-host ""

# An example of working and not working attempts to write to 'drive' and :HKCR
# Add Powershell to Windows right click menu

# Step 21 -Give user a choice first##############################################################################################

Step-Progress

# $response = Read-Host "Do you want to add Open Powershell as (Admin) to the right click context menu now? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    Write-host "Setting Powershell as Admin on the Windows Right Click Context Menu now..." -ForegroundColor Yellow

$menu = 'AIT Windows PowerShell Here as Administrator'
# $command = "$PSHOME\powershell.exe -NoExit -NoProfile -Command ""Set-Location '%V'"""
$command = "$PSHOME\powershell.exe -NoExit -NoProfile -Command ""Start-Process PowerShell -ArgumentList '-NoExit -NoProfile -Command Set-Location ''%V''' -Verb RunAs"""


'directory', 'directory\background', 'drive' | ForEach-Object {
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name runas\command -Force |
    Set-ItemProperty -Name '(default)' -Value $command -PassThru |
    Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
    Set-ItemProperty -Name HasLUAShield -Value ''
}

# } elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Continuing to the next script block.."
    
# } else {
#    Write-Host "Invalid input. Please enter Y or N."
# }
Write-Host "Ready for more :-) " -ForegroundColor DarkYellow

##########################################################ABOVE WORKS###########################################################

# 'Directory',
# ' Directory\Background',
# 'Drive' | ForEach-Object {
#  $Path = "Registry::HKEY_CLASSES_ROOT\$_\shell\PowerShellHere";
#  New-Item -Path $Path -Name 'command' -Force | Out-Null;
#  Set-ItemProperty -Path "$Path\command" -Name '(default)' -Value 'PowerShell -WindowStyle Maximized -NoExit -NoLogo -Command Set-Location "%V"';
#  Set-ItemProperty -Path $Path -Name '(default)' -Value 'PowerShell';
#  Set-ItemProperty -Path $Path -Name 'Icon' -Value "${Env:WinDir}\System32\WindowsPowerShell\v1.0\powershell.exe,0";
# }
########################################################DOES NOT WORK###########################################################

# Path to the registry key
# $regPath = "HKLM:\SOFTWARE\Classes\Directory\Background\shell\PowerShellAsAdmin"
# $regCommandPath = "HKLM:\SOFTWARE\Classes\Directory\Background\shell\PowerShellAsAdmin\command"

# Create registry keys and values
# New-Item -Path $regPath -Force | Out-Null
# New-ItemProperty -Path $regPath -Name "(Default)" -Value "Open PowerShell window here as administrator" -PropertyType String -Force | Out-Null
# New-ItemProperty -Path $regPath -Name "Extended" -Value $null -PropertyType String -Force | Out-Null
# New-ItemProperty -Path $regPath -Name "HasLUAShield" -Value $null -PropertyType String -Force | Out-Null
# New-ItemProperty -Path $regPath -Name "Icon" -Value "powershell.exe" -PropertyType String -Force | Out-Null
#
# New-Item -Path $regCommandPath -Force | Out-Null
# New-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "PowerShell -windowstyle hidden -Command `"Start-Process cmd -ArgumentList '/s,/k,pushd,%V && start PowerShell && exit' -Verb RunAs`"" -PropertyType String -Force | Out-Null
#
########################################################DOES NOT WORK###########################################################

# Step 22 -Add Advanced IT - High Performance Plan from c:\tech_folder\libs\power directory#####################################

Step-Progress

# Give user a choice first
$response = Read-Host "Do you want to add Advanced IT - High Performance Power Plan? << Laptops Only, >> << Do not run on Towers Dude >> (Y/N)"

# Check the response
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "Importing Advanced IT High Performance Plan now..." -ForegroundColor Yellow

    # Main script
    $libsPath = "C:\Tech_Folder\Libs\power"

    Write-Host "Checking for power plans in $libsPath"

    # Check if the folder exists
    if (Test-Path $libsPath) {
        Write-Host "Import folder found."

        # Get all files in the folder
        $allFiles = Get-ChildItem -Path $libsPath

        # Check if there are any files
        if ($allFiles.Count -gt 0) {
            Write-Host "Files available for import:"

            # Loop through each file
            foreach ($file in $allFiles) {
                # Extract the name of the file
                $fileName = $file.Name
                Write-Host "Found file: $fileName"

                # Ask the user if they want to import the file
                $importChoice = Read-Host "Do you want to import '$fileName'? (Yes/No)"
                
                # If the user chooses 'Yes', import the file
                if ($importChoice -eq "Yes") {
                    Import-PowerPlan -FilePath $file.FullName
                  #  Powercfg -import "c:\Tech_Folder\Libs\power\$file.Name
                }
            }
        } else {
            Write-Host "No files found in the import folder."
        }
    } else {
        Write-Host "Import folder not found."
    }
}
elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Continuing to the next script block.."
}
else {
    Write-Host "Invalid choice. Please enter Y or N."
}


######################################################################################################################################

########################################################################################################################

# Step 23 -Kill all Hanging tasks on right click menu

# $response = Read-Host "Do you want to add 'Kill all not responding tasks' to the desktop background right-click context menu now? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    
    Step-Progress
    Write-host "Adding 'Kill all not responding tasks' to the desktop background right-click context menu now..." -ForegroundColor Yellow

    $regPath = "Registry::HKEY_CLASSES_ROOT\DesktopBackground\Shell\KillNRTasks"
    $regCommandPath = "$regPath\command"

    # Create the registry keys
    New-Item -Path $regPath -Force | Out-Null
    New-Item -Path $regCommandPath -Force | Out-Null

    # Set the values for the keys
    Set-ItemProperty -Path $regPath -Name "icon" -Value "taskmgr.exe,-30651"
    Set-ItemProperty -Path $regPath -Name "MUIVerb" -Value "Kill all not responding tasks"
    Set-ItemProperty -Path $regPath -Name "Position" -Value "Top"
    Set-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "taskkill.exe /f /fi 'status eq Not Responding'; Read-Host 'Press Enter to exit'"
    
    Write-Host "The 'Kill all not responding tasks' has been added to the desktop background right-click context menu." -ForegroundColor Green
# } elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "Continuing to the next script block..."
# } else {
#   Write-Host "Invalid input. Please enter Y or N."
# }

Write-Host "Ready for more :-)" -ForegroundColor DarkYellow
Write-Host "We will be updating our script with more performance tweaks soon" -ForegroundColor Green

start-sleep 2

# Step 24 Windows Updates ###################################################################################

step-progress

# Function to get installed Windows updates
function Get-InstalledUpdates {
    Write-Host "Fetching installed updates..."
    $installedUpdates = Get-HotFix
    $installedUpdates | Select-Object -Property Description, InstalledOn | Format-Table -AutoSize
}

# Function to get available Windows updates
function Get-AvailableUpdates {
    Write-Host "Fetching available updates..."
    
    # Ensure Windows Update module is available
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "PSWindowsUpdate module is not installed. Installing..."
        Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
    }
    
    # Import the module
    Import-Module PSWindowsUpdate

    # Get available updates
    $availableUpdates = Get-WindowsUpdate
    $availableUpdates | Select-Object -Property Title, KB, Size | Format-Table -AutoSize
}

# Function to download and install available updates
function Install-Updates {
    Write-Host "Downloading and installing updates..."
    
    # Ensure Windows Update module is available
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "PSWindowsUpdate module is not installed. Installing..."
        Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
    }
    
    # Import the module
    Import-Module PSWindowsUpdate

    # Install updates
    Install-WindowsUpdate -AcceptAll -AutoReboot
}

# Main script
function Main {
    # Get installed updates
    Write-Host "=== Installed Updates ==="
    Get-InstalledUpdates
    
    # Get available updates
    Write-Host "`n=== Available Updates ==="
    Get-AvailableUpdates
    
    # Ask user if they want to download and install updates
    $response = Read-Host -Prompt "Do you want to download and install the available updates now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {
        Install-Updates
        Write-Host "Updates are being downloaded and installed."
    } else {
        Write-Host "Skipping updates installation."
    }
}

# step 25  Prevent Windows from upgrading to Windows 11

Step-Progress

Write-Host ""
Write-Host ""
Write-Host "Preventing Windows 10 from upgrading to Windows 11" -ForegroundColor White

Write-Host "Setting WindowsUpdate TargetReleaseVersion to 22H2." -ForegroundColor Yellow
Step-Progress

# Set WindowsUpdate TargetReleaseVersion to 22H2
$WindowsUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$TargetReleaseVersionName = "TargetReleaseVersion"
$TargetReleaseVersionValue = 1
$TargetReleaseVersionInfoName = "TargetReleaseVersionInfo"
$TargetReleaseVersionInfoValue = "22H2"

# Check if the registry key exists, if not, create it
if (-not (Test-Path $WindowsUpdatePath)) {
    New-Item -Path $WindowsUpdatePath -Force | Out-Null
}

Set-ItemProperty -Path $WindowsUpdatePath -Name $TargetReleaseVersionName -Value $TargetReleaseVersionValue -ErrorAction SilentlyContinue
Set-ItemProperty -Path $WindowsUpdatePath -Name $TargetReleaseVersionInfoName -Value $TargetReleaseVersionInfoValue -ErrorAction SilentlyContinue

Write-Output "WindowsUpdate TargetReleaseVersion set to 22H2."
Write-Host "Script Completed" -ForegroundColor Cyan
Step-Progress

Write-Host "All Tasks Completed Successfully" -ForegroundColor Green
Start-Sleep -Seconds 2

# Here you can add the rest of your script blocks similarly, organizing them into functions and calling them based on user input.
# Create registry keys for adding "Right click open as Command Admin" context menu
# Path to the registry key
$regPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2"
$regCommandPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2\command"

# Create registry keys and values
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "(Default)" -Value "@shell32.dll,-8506" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Icon" -Value "cmd.exe" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Position" -Value "Top" -PropertyType String -Force | Out-Null

# Set the command for the context menu item
New-Item -Path $regCommandPath -Force | Out-Null
New-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "cmd.exe /k cd %1" -PropertyType String -Force | Out-Null

Write-Host "Command as Admin added to the Windows Right Click Context Menu." -ForegroundColor Green

Write-Host "Setting WindowsUpdate TargetReleaseVersion to 22H2." -ForegroundColor Yellow
Step-Progress

# Set WindowsUpdate TargetReleaseVersion to 22H2
$WindowsUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$TargetReleaseVersionName = "TargetReleaseVersion"
$TargetReleaseVersionValue = 1
$TargetReleaseVersionInfoName = "TargetReleaseVersionInfo"
$TargetReleaseVersionInfoValue = "22H2"

# Check if the registry key exists, if not, create it
if (-not (Test-Path $WindowsUpdatePath)) {
    New-Item -Path $WindowsUpdatePath -Force | Out-Null
}

Set-ItemProperty -Path $WindowsUpdatePath -Name $TargetReleaseVersionName -Value $TargetReleaseVersionValue -ErrorAction SilentlyContinue
Set-ItemProperty -Path $WindowsUpdatePath -Name $TargetReleaseVersionInfoName -Value $TargetReleaseVersionInfoValue -ErrorAction SilentlyContinue

Write-Output "WindowsUpdate TargetReleaseVersion set to 22H2."
Write-Host "Script Completed" -ForegroundColor Cyan
Step-Progress

Write-Host "All Tasks Completed Successfully" -ForegroundColor Green
Start-Sleep -Seconds 2

# Here you can add the rest of your script blocks similarly, organizing them into functions and calling them based on user input.
# Create registry keys for adding "Right click open as Command Admin" context menu
# Path to the registry key
$regPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2"
$regCommandPath = "HKLM:\SOFTWARE\Classes\Directory\shell\cmd2\command"

# Create registry keys and values
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "(Default)" -Value "@shell32.dll,-8506" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Icon" -Value "cmd.exe" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Position" -Value "Top" -PropertyType String -Force | Out-Null

# Set the command for the context menu item
New-Item -Path $regCommandPath -Force | Out-Null
New-ItemProperty -Path $regCommandPath -Name "(Default)" -Value "cmd.exe /k cd %1" -PropertyType String -Force | Out-Null

Write-Host "Command as Admin added to the Windows Right Click Context Menu." -ForegroundColor Green

################################################################################################################

# step 26 create Advanced IT Deep Clean shortcut / create Tech_Folder / icon on user computer

step-progress

Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/c /Sageset:65535 /Sagerun:65535" -NoNewWindow -Wait

# Define the target directory and icon source path
$targetDir = "C:\Tech_Folder"
$iconSourcePath = "$PSScriptRoot\Libs\Icons\Win11_ico\Shell32_250.ico"
$iconDestinationPath = "$targetDir\Libs\Icons\Win11_ico\Shell32_250.ico"

# Check if the target directory exists, if not, create it
if (-Not (Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# Copy the icon to the target directory
Copy-Item -Path $iconSourcePath -Destination $iconDestinationPath -Force

# Create a shortcut on the desktop and start menu
$shortcutName = "Advanced IT Deep Clean"
$shortcutPathDesktop = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "$shortcutName.lnk")
$shortcutPathStartMenu = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("StartMenu"), "$shortcutName.lnk")
$targetPath = "%comspec%"
$arguments = "/c cleanmgr /Sagerun:65535"
$iconPath = $iconDestinationPath  # Use the copied icon path

function Create-Shortcut {
    param (
        [string]$shortcutPath
    )
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Arguments = $arguments
    $shortcut.IconLocation = $iconPath
    $shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($targetPath)
    $shortcut.Save()

    # Set the shortcut to run as administrator
    $shell = New-Object -ComObject Shell.Application
    $shortcutFile = $shell.Namespace([System.IO.Path]::GetDirectoryName($shortcutPath)).ParseName([System.IO.Path]::GetFileName($shortcutPath))
    $shortcutFile.InvokeVerb("runas")
}

# Create shortcuts
Create-Shortcut -shortcutPath $shortcutPathDesktop
Create-Shortcut -shortcutPath $shortcutPathStartMenu

# step 27 - Windows activation

Step-Progress

Write-Host "Windows hardware ID based activation script, launching now..." -ForegroundColor White

$response = Read-Host "Do you want to Activate Windows Now (Y/N)"

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "Activating Windows..." -ForegroundColor Yellow
    Write-Host "Please wait while your Windows Operating System is Permanently activated by Hardware Chipset ID  " -ForegroundColor Cyan
    & ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID
} elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "User opted not to Activate Windows now." -ForegroundColor Yellow
}


Write-Host "YOU ARE ALMOST THERE !!! -Now lets assist you with some OS based front end settings pages :-" -ForegroundColor Green

# Run the main script
# Main

# Function to open a specific settings page
function Open-SettingsPage {
    param (
        [string]$SettingsUri,
        [string]$Message
    )
    
    Write-Host $Message
    Start-Process $SettingsUri
}

# Function to pause the script and wait for user confirmation
function Wait-ForUserConfirmation {
    Write-Host "Please review the settings in the opened window."
    Write-Host "Once you have reviewed or made changes, press Enter to continue..."
    
    # Wait for user input to proceed
    Read-Host -Prompt "Press Enter to continue"
}

# Main script
function Main {
    # Open Location and Privacy Settings
    Open-SettingsPage -SettingsUri "ms-settings:privacy-location" -Message "Opening Location and Privacy settings..."
    Wait-ForUserConfirmation

    # Open Privacy Settings
    Open-SettingsPage -SettingsUri "ms-settings:privacy" -Message "Opening Privacy settings..."
    Wait-ForUserConfirmation

    # Open Notifications & Actions Settings
    Open-SettingsPage -SettingsUri "ms-settings:notifications" -Message "Opening Notifications & actions settings..."
    Wait-ForUserConfirmation

    # Open Taskbar Settings
    Open-SettingsPage -SettingsUri "ms-settings:taskbar" -Message "Opening Taskbar settings..."
    Wait-ForUserConfirmation

    # Open Game Mode Settings
    Open-SettingsPage -SettingsUri "ms-settings:gaming-gamebar" -Message "Opening Game Mode settings..."
    Wait-ForUserConfirmation

    Write-Host "All settings have been reviewed."
}

# Run the main function of this section of code
Main


#step 30 -Enable Remote Powershell

Step-Progress

# This script configures WinRM and sets TrustedHosts for PowerShell remoting.
# Sections are marked to indicate where they should be run: Local, Remote, or Both.

# Section 1: Verify and Start WinRM Service (Both)
# This section ensures that the WinRM service is running on both local and remote machines.
Write-Host ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ACTIVATE REMOTE ACCESS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" -ForegroundColor Blue

$response = Read-Host "Do you want to install Powershell Remoting access now (Y/N)"

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host "Activating remote access..." -ForegroundColor Yellow

Write-Host "Starting WinRM service..."
Start-Service WinRM

# Section 2: Configure WinRM (Both)
# This section configures the WinRM service if it is not already configured.
Write-Host "Configuring WinRM service..."
winrm quickconfig -force

# Section 3: Check and Set Network Profile (Both)
# This section ensures that the network profile is set to Private or Domain.
Write-Host "Setting network profile to Private..."
Set-NetConnectionProfile -NetworkCategory Private

# Section 4: Set TrustedHosts (Local)
# This section sets the TrustedHosts list on the local machine.
# Replace '*' with specific IP addresses or hostnames if needed.
Write-Host "Setting TrustedHosts..."
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'

# Section 5: Enable PowerShell Remoting (Both)
# This section enables PowerShell Remoting on both local and remote machines.
Write-Host "Enabling PowerShell Remoting..."
Enable-PSRemoting -Force

# Section 6: Configure Firewall (Both)
# This section ensures that the necessary firewall rules are in place to allow WinRM traffic.
Write-Host "Enabling firewall rule for WinRM..."
Enable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"

Write-Host "Configuration complete. WinRM and TrustedHosts are set up."
Write-Host ""
Write-Host "You opted to setup remote access, invoking url access to Python to send data now" -ForegroundColor White
Write-Host ""

# Step 31 - 'Force' sending of data to remote Python server now, in event of remote access acceptance
Step-Progress

Write-Host ""
Write-Host "Please wait while we we collect Local pc data and upload to the Python server url" -ForegroundColor Yellow

# Retrieve the local PC's IP address and date/time
$localIpAddresses = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.AddressFamily -eq "IPv4"}).IPAddress
$localDateTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

# Define the remote PC's IP address and the URL to send the data to
$remotePcIp = "10.0.0.179"
$port = 8080
$path = "/receive-ip"

# Construct the URL with proper variable expansion
$url = "http://${remotePcIp}:${port}${path}"

# Debug output to check URL formation
Write-Host "Remote IP: $remotePcIp"
Write-Host "Port: $port"
Write-Host "Path: $path"
Write-Host "Constructed URL: $url"

# Create a JSON object with the IP address and date/time
$data = @{
    IPAddress = $localIpAddresses
    DateTime = $localDateTime
} | ConvertTo-Json

# Output the data for debugging
Write-Host "Data: $data"

# Send the data to the remote PC
try {
    Invoke-WebRequest -Uri $url -Method POST -Body $data -ContentType "application/json"
    Write-Host "Data from $localIpAddresses successfully sent to $url."
} catch {
    Write-Error "Failed to send data: $_"
}


} elseif ($response -eq "N" -or $response -eq "n") {
    Write-Host "User opted not to Activate Remote access at this stage." -ForegroundColor Yellow
}

Write-Host "Remote access granted, data uplink completed successfully !" -ForegroundColor Cyan

#step 32 - Run TroubleshootingPacks

# Set base directory path for troubleshooting packs
$basePath = "C:\Windows\diagnostics\system"  # Replace with actual path

# Set directory for storing answer files
$answerFileDirectory = "C:\AnswerFiles"

# Main menu loop
while ($true) {
    # Step 1: List all troubleshooting pack folders (subdirectories in the base path)
    $troubleshooterDirs = Get-ChildItem -Path $basePath -Directory

    # Step 2: Display the troubleshooting packs as a lettered menu
    Write-Host "`nSelect a troubleshooting pack:"
    $letters = @('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
    
    $counter = 0
    $troubleshooterDirs | ForEach-Object {
        Write-Host "$($letters[$counter]). $($_.Name)"
        $counter++
    }

    # Step 3: Display option to exit the script
    Write-Host "0. Exit"

    # Step 4: Read user input for selection (now letters)
    $selection = Read-Host "Enter the letter corresponding to the troubleshooting pack you want to use (0 to exit)"

    # Step 5: Check if the input is valid (either 0 to exit, or a valid letter from the list)
    if ($selection -eq 0) {
        Write-Host "Exiting script." -ForegroundColor Yellow
        break  # Exit the loop and terminate the script
    }

    # Ensure that the letter corresponds to a valid troubleshooting pack
    $selectedIndex = $letters.IndexOf($selection.ToUpper())
    if ($selectedIndex -ge 0 -and $selectedIndex -lt $troubleshooterDirs.Count) {
        # If valid selection (within the range)
        $selectedPack = $troubleshooterDirs[$selectedIndex]
        
        # Construct the path for the answer file
        $answerFilePath = "$answerFileDirectory\$($selectedPack.Name)-answer.xml"

        # Step 7: Check if the answer file exists
        if (Test-Path $answerFilePath) {
            # If answer file exists, offer the user a choice
            Write-Host "`nThe answer file already exists for $($selectedPack.Name). What would you like to do?"
            Write-Host "1. Run the troubleshooter in unattended mode using the existing answer file."
            Write-Host "2. Create a new answer file and then run the troubleshooter in unattended mode."

            $choice = Read-Host "Enter your choice (1 to use existing, 2 to create new)"

            if ($choice -eq 1) {
                # Step 8: Run the troubleshooter in unattended mode using the existing answer file
                Write-Host "Running troubleshooting pack in unattended mode using the existing answer file: $($selectedPack.Name)" -ForegroundColor Cyan
                Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
                Write-Host "The troubleshooting process is complete." -ForegroundColor Green
            } elseif ($choice -eq 2) {
                # Step 9: Create a new answer file and run the troubleshooter in unattended mode
                Write-Host "Creating a new answer file and running the troubleshooting pack: $($selectedPack.Name)" -ForegroundColor Cyan
                Get-TroubleshootingPack $selectedPack.FullName -AnswerFile $answerFilePath
                Write-Host "Answer file created at: $answerFilePath"
                
                # Run the troubleshooter in unattended mode with the new answer file
                Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
                Write-Host "The troubleshooting process is complete." -ForegroundColor Green
            } else {
                Write-Host "Invalid choice. Please select 1 or 2." -ForegroundColor Red
            }
        } else {
            # If the answer file doesn't exist, create it and run the troubleshooter
            Write-Host "Answer file doesn't exist. Creating answer file and running troubleshooting pack: $($selectedPack.Name)" -ForegroundColor Cyan
            Get-TroubleshootingPack $selectedPack.FullName -AnswerFile $answerFilePath
            Write-Host "Answer file created at: $answerFilePath"

            # Step 9: Run the troubleshooter in unattended mode
            Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
            Write-Host "The troubleshooting process is complete." -ForegroundColor Green
        }
    } else {
        # Handle invalid selection (if the user selects a letter that's out of range)
        Write-Host "Invalid selection! Please select a valid letter from the list (A to $($letters[$troubleshooterDirs.Count-1]), or 0 to exit)." -ForegroundColor Red
    }

    # Wait for user input to return to the main menu
    Write-Host "`nPress Enter to return to the main menu."
    Read-Host  # Wait for Enter key to continue
}


#step 33 - Install Web based applications

Step-Progress

Write-Host "Web Apps are being installed, please wait until fully completed." -ForeGround Yellow
Write-Host "Your screen may flicker Black during this process..." -ForegroundColor DarkYellow
Start-Sleep 5
Write-Host ""
Write-Host ""
Write-Host "Greasing the pot..."
Write-Host "Lubing the spiders."
Start-Sleep 2
# Get the drive letter of the script location
$scriptDrive = (Get-Item -Path $MyInvocation.MyCommand.Path).PSDrive.Root

# Define source and destination paths
$sourcePath = Join-Path -Path $scriptDrive -ChildPath "Tech_Folder\Tech Scripts\Mal_Main\Current\Web Applications\Icons"
$destinationPath = "C:\Tech_Folder\Libs\"

# Check if the destination path exists, if not, create it
if (!(Test-Path -Path $destinationPath)) {
    New-Item -Path $destinationPath -ItemType Directory
}

# Copy the directories and files from the source to the destination with overwrite
Write-Host "Copying files from '$sourcePath' to '$destinationPath'..."
Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force -PassThru | ForEach-Object {
    Write-Host "Copied: $($_.FullName)"
}
Write-Host "Copy operation completed."
clear

Write-Host "Web Apps are being installed, please wait until fully completed......." -ForeGround Yellow
Write-Host "Your screen may FLICKER BLACK during this process. Just chill Dude..." -ForegroundColor DarkYellow

Sleep 5

# Define variables for multiple apps
$apps = @(
    @{
        Name = "CoPilot AI"
        URL = "https://copilot.microsoft.com/?showconv=1"
        ShortcutPath = "C:\Users\$env:USERNAME\Desktop\CoPilot AI.lnk"
        StartMenuPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\CoPilot AI.lnk"
        IconPath = "c:\Tech_Folder\Libs\Icons\CoPilot AI.ico"
    },
    @{
        Name = "ChatGPT"
        URL = "https://chatgpt.com/"
        ShortcutPath = "C:\Users\$env:USERNAME\Desktop\ChatGPT.lnk"
        StartMenuPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ChatGPT.lnk"
        IconPath = "c:\Tech_Folder\Libs\Icons\ChatGPT.ico"
    },
    @{
        Name = "You Tube"
        URL = "https://youtube.com/"
        ShortcutPath = "C:\Users\$env:USERNAME\Desktop\You Tube.lnk"
        StartMenuPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\You Tube.lnk"
        IconPath = "c:\Tech_Folder\Libs\Icons\YouTube.ico"
    },
    @{
        Name = "GMail"
        URL = "https://accounts.google.com/v3/signin/identifier?ifkv=AVdkyDm5qQbeXJrjleU2X2tCo7CYsXimqTivnh8oFqz4cbQeHahUp0srdD96T90ZFFeOzYBrvOZurg&rip=1&sacu=1&service=mail&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S-1859782013%3A1738140294865268&ddm=1"
        ShortcutPath = "C:\Users\$env:USERNAME\Desktop\GMail.lnk"
        StartMenuPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\GMail.lnk"
       # IconPath = "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications\_crx__lijapnbnnlaicnmjicmpkdldpehcebgj\Gmail.ico"
       IconPath = "c:\Tech_Folder\Libs\Icons\GMail.ico"
    },
    @{
        Name = "Google Maps"
        URL = "https://www.google.co.za/maps"
        ShortcutPath = "C:\Users\$env:USERNAME\Desktop\Google Maps.lnk"
        StartMenuPath = "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Google Maps.lnk"
        # IconPath = "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications\_crx__eoonbjjmpcjalchbbofgpefidopaebdh\Google Maps.ico"
        IconPath = "c:\Tech_Folder\Libs\Icons\Google Maps.ico"
    }
    # Add more apps as needed...
)

$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$SourcePath = $edgePath

foreach ($app in $apps) {
    # Install the Web Application using Edge
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $edgePath
    $psi.Arguments = "--app=$($app.URL)"
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    [System.Diagnostics.Process]::Start($psi)

    Start-Sleep -Seconds 4 # Giving time for Edge process to stabilize

    # Create Desktop Shortcut
    $WScriptShell = New-Object -ComObject ("WScript.Shell")
    $Shortcut = $WScriptShell.CreateShortcut($app.ShortcutPath)
    $Shortcut.TargetPath = $SourcePath
    $Shortcut.Arguments = "--app=$($app.URL)"
    $Shortcut.IconLocation = $app.IconPath
    $Shortcut.Save()

  # Log installed apps
    Write-Host "Installed: $($app.Name) from $($app.URL)" -ForegroundColor Cyan
    
    }


  # Close all Edge app windows
Stop-Process -Name "msedge" -Force

Start-Sleep 2 

# Run the Final message
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Tweak Settings completed, please reboot your computer"-ForegroundColor Blue
Write-Host ""
Write-Host "All operations completed successfully. Your system is now optimized for performance." -ForegroundColor White
Write-Host ""
Write-Host "Thank you for using Windows Tweak & Squeak Toolbox!" -ForegroundColor Cyan
Write-Host ""
Write-Host "....We will be adding more soon. MGM 1-9-24"

# Run out message - Mission Impossible

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-Host "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-Host "Nothing is impossible ! Believe with all your heart and LIVE in the moment you SEE !! " -ForegroundColor White
Write-Host "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-Host "________________________________________________________________________________________________>>>" -ForegroundColor Green


try {
	[System.Console]::Beep(784,150)
	Start-Sleep -m 75
	[System.Console]::Beep(784,150)
	Start-Sleep -m 750
	[System.Console]::Beep(932,150)
	Start-Sleep -m 75
	[System.Console]::Beep(1047,150)
	Start-Sleep -m 75
	[System.Console]::Beep(784,150)
	Start-Sleep -m 75
	[System.Console]::Beep(784,150)
	Start-Sleep -m 150
	[console]::Beep(699,150)
	Start-Sleep -m 75
	[System.Console]::Beep(740,150)
	Start-Sleep -m 75
	[System.Console]::Beep(784,150)
	Start-Sleep -m 150
	[System.Console]::Beep(784,150)
	Start-Sleep -m 150
	[System.Console]::Beep(932,150)
	Start-Sleep -m 75
	[System.Console]::Beep(1047,150)
	Start-Sleep -m 75
	[System.Console]::Beep(784,150)
	Start-Sleep -m 150
	[System.Console]::Beep(784,150)
	Start-Sleep -m 150
	[System.Console]::Beep(699,150)
	Start-Sleep -m 75
	[System.Console]::Beep(740,150)
	Start-Sleep -m 75
	[System.Console]::Beep(932,150)
	[System.Console]::Beep(784,150)
	[System.Console]::Beep(587,1200)
	Start-Sleep -m 37
	[System.Console]::Beep(932,150)
	[System.Console]::Beep(784,150)
	[System.Console]::Beep(554,1200)
	Start-Sleep -m 37
	[System.Console]::Beep(932,150)
	[System.Console]::Beep(784,150)
	[System.Console]::Beep(523,1200)
	Start-Sleep -m 75
	[System.Console]::Beep(466,150)
	[System.Console]::Beep(523,150)
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}

Write-Host "100 % complete, (⚠️ please reboot now..)"