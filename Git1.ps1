Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Script GUI"
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::DarkGray  # Set form background color

# Create the main container panel (splits left and right)
$mainPanel = New-Object System.Windows.Forms.SplitContainer
$mainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$mainPanel.SplitterDistance = 200  # Adjust the left panel width
$mainPanel.FixedPanel = 'None'

# Left panel (Checkboxes)
$panelLeft = New-Object System.Windows.Forms.Panel
$panelLeft.Dock = [System.Windows.Forms.DockStyle]::Fill
$panelLeft.BackColor = [System.Drawing.Color]::DarkGray  # Left panel color

# Scrollable container for checkboxes
$scrollPanelLeft = New-Object System.Windows.Forms.FlowLayoutPanel
$scrollPanelLeft.Dock = [System.Windows.Forms.DockStyle]::Fill
$scrollPanelLeft.AutoScroll = $true
$scrollPanelLeft.FlowDirection = 'TopDown'
$scrollPanelLeft.WrapContents = $false
$scrollPanelLeft.BackColor = [System.Drawing.Color]::DarkGray

# Define human-friendly checkbox labels
$checkboxLabels = @("Disable Wifi Hotspot and Reporting Services", "Enable Long File Names", "Disable UserActivity", "Harden and secure location and privacy settings", "Disabling adverts", "Enable Game mode and optimise", "Create an option to enable or disable hibernation", "Disable homegroup related services", "Disable Application Compatibility", "Enable English Only language", "Display performance mode", "Install choco and winget", "Reset Network and Firewall with netsh", "Disable Teredo", "Disk Cleanup", "GPEdit enable", "Add powershell as Admin to Windows X and rt click context menus", "Add Advanced IT - High Performance Plan", "Add Kill all not responding tasks on right-click context menu", "Windows Updates", "Lock Windows 10 prevent 11 upgrade", "Advanced IT Deep Clean shortcut", "Settings tweak walkthrough", "Run troubleshooting packs with unattended answer files", "Install Web Apps" )

# Create checkboxes
$checkBoxes = @()
foreach ($label in $checkboxLabels) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $label
    $checkbox.Width = 280
    $checkbox.ForeColor = [System.Drawing.Color]::White  # Set text color
    $checkBoxes += $checkbox
    $scrollPanelLeft.Controls.Add($checkbox)
}

$panelLeft.Controls.Add($scrollPanelLeft)
$mainPanel.Panel1.Controls.Add($panelLeft)

# Right panel (Output box)
$panelRight = New-Object System.Windows.Forms.Panel
$panelRight.Dock = [System.Windows.Forms.DockStyle]::Fill
$panelRight.BackColor = [System.Drawing.Color]::DarkGray

# Output RichTextBox (supports colored text)
$outputTextBox = New-Object System.Windows.Forms.RichTextBox
$outputTextBox.Multiline = $true
$outputTextBox.ReadOnly = $true
$outputTextBox.ScrollBars = "Vertical"
$outputTextBox.Dock = "Fill"
$outputTextBox.BackColor = [System.Drawing.Color]::Black  # Black background
$outputTextBox.ForeColor = [System.Drawing.Color]::LightGray  # Default light gray text
$outputTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)

# Function to write colored text to RichTextBox
function Write-OutputToTextBox {
    param([string]$text, [string]$color = "LightGray")
    
    $outputTextBox.SelectionStart = $outputTextBox.TextLength
    $outputTextBox.SelectionLength = 0
    
    switch ($color) {
        "Yellow" { $outputTextBox.SelectionColor = [System.Drawing.Color]::Yellow }
        "Green" { $outputTextBox.SelectionColor = [System.Drawing.Color]::LimeGreen }
        "Red" { $outputTextBox.SelectionColor = [System.Drawing.Color]::Red }
        Default { $outputTextBox.SelectionColor = [System.Drawing.Color]::LightGray }
    }
    
    $outputTextBox.AppendText($text + "`r`n")
    $outputTextBox.SelectionColor = $outputTextBox.ForeColor  # Reset color
}

# Function for Y/N Confirmation (Corrected)
# Function to display a confirmation dialog box
function Ask-UserConfirmation {
    param (
        [string]$Message,
        [string]$Title = "Confirmation"
    )

    Add-Type -AssemblyName System.Windows.Forms

    # Create the pop-up dialog
    $response = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)

    # Return $true for Yes, $false for No
    return ($response -eq [System.Windows.Forms.DialogResult]::Yes)
}  # <-- Corrected closing brace

# Run Button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = "Run Selected Scripts"
$runButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$runButton.Height = 40
$runButton.BackColor = [System.Drawing.Color]::Black
$runButton.ForeColor = [System.Drawing.Color]::LightGray
$runButton.Add_Click({
    $outputTextBox.Clear()
    
    foreach ($checkbox in $checkBoxes) {
        if ($checkbox.Checked) {
            Write-OutputToTextBox "Running script for: $($checkbox.Text)" "Yellow"
            
            switch ($checkbox.Text) {
                "Disable Wifi Hotspot and Reporting Services" {
                    try {
                        Write-OutputToTextBox "Disabling Wifi Hotspot reporting and AutoConnect to Wifisense Hotspots" "Yellow"
                        Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Value 0 -ErrorAction Stop
                        Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Value 0 -ErrorAction Stop
                        Write-OutputToTextBox "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting set to 0" "Green"
                        Write-OutputToTextBox "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots set to 0" "Green"
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Enable Long File Names" {
                    try {
                      # Step 2 - Enable long file names
#step-progress
                        Write-OutputToTextBox "Setting Registry to allow Long File Name Conventions" "Yellow"
                        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -ErrorAction Stop
                        Write-OutputToTextBox "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem LongPathsEnabled set to 1" "Green"
                        Write-OutputToTextBox "Rebuilding Windows 10 and Windows 11 -Icon Cache..." "Yellow"
                        Start-Process -FilePath "$env:SystemRoot\system32\ie4uinit.exe" -ArgumentList "-show" -NoNewWindow -PassThru -ErrorAction Stop | Wait-Process
                        Write-OutputToTextBox "Icon Cache Rebuilt." "Green"
                        Write-OutputToTextBox "Rebuilding Thumbnail Cache..." "Yellow"
                        Start-Process -FilePath "cmd.exe" -ArgumentList "/c del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" -NoNewWindow -PassThru -ErrorAction Stop | Wait-Process
                        Write-OutputToTextBox "Thumbnail Cache Rebuilt." "Green"
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Disable UserActivity" {
                    try {
                       # Step 3 -Disable UserActivity###################################################################################################
#Step-Progress

Write-OutputToTextBox "Disabling UserActivity" -ForegroundColor Green

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
Write-OutputToTextBox "$Name1, Set to Disabled", "$Name2, Set to Disabled", "$Name3, Set to Disabled" -ForegroundColor Yellow

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Harden and secure location and privacy settings" {
                    try {
                        # Step 4 -Location and privacy settings########################################################################################
#Step-Progress

Write-OutputToTextBox "Setting ConsentPromptBehaviourAdmin to 0 under System" -ForegroundColor Green
# Set ConsentPromptBehaviorAdmin to 0 under Policies\System
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -ErrorAction SilentlyContinue

Write-OutputToTextBox "ConsentPromptBehaviorAdmin set to 0 successfully."

Write-OutputToTextBox "Disabling Location Tracking services -- Bill Gates sucks" -ForegroundColor Cyan

Start-Sleep -Seconds 2

# Set registry value to Deny under CapabilityAccessManager\ConsentStore\location
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -ErrorAction SilentlyContinue

# Set SensorPermissionState to 0 under Sensor\Overrides
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value 0 -ErrorAction SilentlyContinue

# Set Status to 0 under lfsvc\Service\Configuration
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Value 0 -ErrorAction SilentlyContinue

# Set AutoUpdateEnabled to 0 under SYSTEM\Maps
Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Value 0 -ErrorAction SilentlyContinue

Write-OutputToTextBox "Registry settings updated successfully. Consent Store location disabled, Sensor Overides enabled, Map updates disabled except Manual" -ForegroundColor Yellow

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Disabling adverts" {
                    try {
                        # Step 5 -Disable adverts#######################################################################################################
#Step-Progress

Write-OutputToTextBox "Disabling adverts from Amazon.com main hub advertisering authority" -ForegroundColor Red

$adlist = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host' -ErrorAction SilentlyContinue
$adfile = "$env:windir\System32\drivers\etc\hosts"
$adlist | Add-Content -PassThru $adfile -ErrorAction SilentlyContinue

Write-OutputToTextBox "https://raw.githubusercontent.com/Brandonbr1/ad-list-hosts/main/host  -- Added to database" -ForegroundColor Yellow
start-sleep 2

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Enable Game mode and optimise" {
                    try {
                       #Step - 6 Enable game mode, disable unneeded

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

Write-OutputToTextBox "Game DVR Policies, Set to disabled" -ForegroundColor Green
start-sleep 2
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
        # Case 1: Enable or disable hibernation
                "Create an option to enable or disable hibernation" {
                    try {
                        if (Ask-UserConfirmation "Do you want to enable Hibernation?") {
                            Write-OutputToTextBox "User chose YES, Enabling Hibernation and removing edit option..." "Yellow"

                            Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Value 1 -ErrorAction SilentlyContinue

                            if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
                                New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Force | Out-Null
                            }
                            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Value 0 -ErrorAction SilentlyContinue

                            Write-OutputToTextBox "Hibernation Enabled, Edit option removed." "Green"
                        } else {
                            Write-OutputToTextBox "Disabling Hibernation and removing edit option..." "Yellow"

                            Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernateEnabled" -Value 0 -ErrorAction SilentlyContinue

                            if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
                                New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Force | Out-Null
                            }
                            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Value 0 -ErrorAction SilentlyContinue

                            Write-OutputToTextBox "Hibernation Disabled, Edit option removed." "Green"
                        }
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }

                # Case 2: Disable homegroup-related services
                "Disable homegroup related services" {
                    try {
                        $listenerService = Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue
                        if ($listenerService -ne $null) {
                            Set-Service -Name HomeGroupListener -StartupType Manual
                            Write-OutputToTextBox "Service 'HomeGroupListener' set to Manual startup type."
                        } else {
                            Write-OutputToTextBox "Service 'HomeGroupListener' not found. Skipping..."
                        }

                        $providerService = Get-Service -Name HomeGroupProvider -ErrorAction SilentlyContinue
                        if ($providerService -ne $null) {
                            Set-Service -Name HomeGroupProvider -StartupType Manual
                            Write-OutputToTextBox "Service 'HomeGroupProvider' set to Manual startup type."
                        } else {
                            Write-OutputToTextBox "Service 'HomeGroupProvider' not found. Skipping..."
                        }

                        Write-OutputToTextBox "Homegroup Disabled and set to startup type manual" -ForegroundColor Green
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                
                "Disable Application Compatibility" {
                    try {
                     # Step 9 -Disable Application Compatibility ###################################################################################################
#Step-Progress

Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox "Setting Group Policy Settings to 'disabled' for Application Compatibility in the registry to speed up Windows" -ForegroundColor Green
Write-OutputToTextBox ""
Write-OutputToTextBox ""

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
Write-OutputToTextBox "The following settings are found in the Group Policy Editor //Computer Config/Administrative Templates/Windows Components/Application Compatability" -ForeGroundColor Cyan
Write-OutputToTextBox "Group Policy Objects are written to the registry in a single direction, changes made here will not reflect in the GPO" -ForeGroundColor Cyan
Write-OutputToTextBox "The Script will automatically check for the existence of these settings in the registry and modify them as needed :-)" -ForeGroundColor Cyan

Sleep 3
Write-OutputToTextBox "Prevent access to 16-bit applications" -ForeGroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name1 - Set to Enabled" -ForegroundColor Yellow

Write-OutputToTextBox "Remove Program Compatibility Property Page" -ForegroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name2 - Set to Enabled" -ForegroundColor Yellow

Write-OutputToTextBox "Turn Off Application Telemetry" -ForeGroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name3 - Set to Disabled -This enables it !" -ForegroundColor Yellow

Write-OutputToTextBox "Turn off Application Compatibility Engine" -ForeGroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name4 - Set to Enabled" -ForegroundColor Yellow

Write-OutputToTextBox "Turn off Program Compatibility Assistant" -ForeGroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name5 - Set to Enabled" -ForegroundColor Yellow

Write-OutputToTextBox "Turn off Inventory Collector - Sorry Microsoft, get lost !" -ForegroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name6 - Set to Enabled" -ForegroundColor Yellow

Write-OutputToTextBox "Turn off SwitchBack Compatibility Engine" -ForeGroundColor White
Write-OutputToTextBox "The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name7 - Set to Disabled" -ForegroundColor White

Write-OutputToTextBox "Turn off Steps Recorder"
Write-OutputToTextBox " The above Group Policy Setting has been modified in HKLM/SW/Policies/Microsoft/Windows/AppCompat/$Name8 - Set to Enabled" -ForegroundColor Yellow

Start-Sleep 4
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Enable English Only language" {
                    try {
                      # Step 10 - Enable English Only language ###########################################################
#step-progress
                       $LangList = Get-WinUserLanguageList

Write-OutputToTextBox "$LangList" -ForegroundColor Gray
#Filter out English language resourceSet files
$EnglishLang = $LangList | where { $_.LanguageTag -eq "en-US" }

# Create a new List to keep only the English Language
$LangListToKeep = @($EnglishLang)

# Set the user Language list to English only
Set-WinUserLanguageList -LanguageList $LangListToKeep -Force -ErrorAction SilentlyContinue

Write-OutputToTextBox "The $EnglishLang language list has been kept as default" -ForegroundColor Green

Start-Sleep -Seconds 2
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Display performance mode" {
                    try {
                   # Step 11 -Display performance mode##############################################################################################
#Step-Progress

Write-OutputToTextBox "Setting display for performance mode" -ForegroundColor Yellow

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

############################################# ADD 2ND STEP progress ######################################################################
#Step-Progress

Write-OutputToTextBox "Display Performance Profiling, enabled." -ForegroundColor Yellow
Write-OutputToTextBox "The following display performance metrics have been tweaked on your system"
Write-OutputToTextBox ""
Write-OutputToTextBox "The following display related tweaks are now set :" -ForeGroundColor Yellow
Write-OutputToTextBox "HKCU:\Control Panel\Desktop -Name DragFullWindows -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Control Panel\Desktop -Name MenuShowDelay -Value set to 200ms" --ForeGroundColor White
Write-OutputToTextBox "HKCU:\Control Panel\Desktop\WindowMetrics -Name MinAnimate -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Control Panel\Keyboard -Name KeyboardDelay -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ListviewAlphaSelect -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ListviewShadow -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAnimations -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects -Name VisualFXSetting -Value set to 3" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\DWM -Name EnableAeroPeek -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value set to 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0" -ForeGroundColor White
Write-OutputToTextBox "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value set to 0" -ForeGroundColor White

Start-Sleep 2
                } catch {
                    Write-OutputToTextBox "Error: $_" "Red"

            }
        }
         "Install choco and winget" {
                    try {
                    # Step 12 -1-Install Chocolatey####################################################################################################

#Step-Progress

#Set-ExecutionPolicy Unrestricted -ErrorAction SilentlyContinue
#Set-ExecutionPolicy AllSigned -ErrorAction SilentlyContinue
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -ErrorAction SilentlyContinue

Write-OutputToTextBox "Choco Installed Mate !!" -ForegroundColor Green

# Step 12 -2-Install Winget########################################################################################################
#Step-Progress

Write-OutputToTextBox "Installing Winget and NuGet package providers ..." -ForeGroundColour Yellow
Write-OutputToTextBox "Invoke with >winget search name or >winget install name ..from command prompt to install software from the net" -ForegroundColor Cyan
start-sleep 2

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue
Install-Module -Name Microsoft.WinGet.Client -ErrorAction SilentlyContinue

start-sleep 1
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Reset Network and Firewall with netsh" {
                    try {
                # Step 13 -Reset Network#########################################################################################################
#Step-Progress

Write-OutputToTextBox "Resetting Network with netsh" -ForegroundColor Red

# Reset WinSock catalog to a clean state
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "winsock", "reset" -ErrorAction SilentlyContinue
# Resets WinHTTP proxy setting to DIRECT
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "winhttp", "reset", "proxy" -ErrorAction SilentlyContinue
# Removes all user configured IP settings
Start-Process -NoNewWindow -FilePath "netsh" -ArgumentList "int", "ip", "reset" -ErrorAction SilentlyContinue

Write-OutputToTextBox "netsh -ArgumentList --winsock, Reset WinSock catalog to a clean state completed" -ForegroundColor White
Write-OutputToTextBox "netsh -ArgumentList --winhttp, reset WinHTTP proxy setting to DIRECT completed" -ForegroundColor White
Write-OutputToTextBox "netsh -ArgumentList --int, ip, Remove all user configured IP settings completed" -ForegroundColor White

Write-OutputToTextBox "Process complete. Please reboot your computer." -ForegroundColor Green
Start-Sleep 8
            } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
               "Disable Teredo" {
    try {
        # Step 14 - Disable Teredo ##########################################################
        Write-OutputToTextBox "Preparing to disable Teredo Tunneling..." -ForegroundColor Yellow
        
        # Ask the user for confirmation
        if (Ask-UserConfirmation "Do you want to disable Teredo Tunneling now?") {
            Write-OutputToTextBox "Disabling Teredo Tunneling..." -ForegroundColor Yellow

            # Define registry path
            $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"

            # Check if the registry key exists, if not, create it
            if (!(Test-Path $registryPath)) {
                New-Item -Path $registryPath -Force | Out-Null
            }

            # Define the registry key name
            $Name1 = "DisabledComponents"

            # Set the registry value to disable Teredo
            Set-ItemProperty -Path $registryPath -Name $Name1 -Value 1 -ErrorAction SilentlyContinue

            # Disable Teredo using netsh
            netsh interface teredo set state disabled
            Write-OutputToTextBox "Command executed: netsh interface teredo set state disabled" -ForegroundColor White

            Write-OutputToTextBox "Teredo Tunneling has been successfully disabled." -ForegroundColor Green
        } else {
            Write-OutputToTextBox "User chose not to disable Teredo Tunneling. Continuing with the script block..." -ForegroundColor Yellow
        }
    } catch {
        Write-OutputToTextBox "An error occurred while disabling Teredo Tunneling: $_" -ForegroundColor Red
    }
}

                "Disk Cleanup" {
                    try {
                      # Step 15 - Disk Cleanup
#step-progress
Write-OutputToTextBox "Initiating disk cleanup operation" -ForegroundColor Yellow

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

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
"GPEdit enable" {
    try {
        # Step 16 - GPEdit enable ###########################################################
        Write-OutputToTextBox "We have finished the performance profiling and enhancements : )" -ForegroundColor White
        Write-OutputToTextBox "Now let's do some Explorer tweaking to pep the system environment for you..." -ForegroundColor Yellow

        Start-Sleep 2

        Write-OutputToTextBox "Inspecting Group Policy Environment on $osVersion.Build ..." -ForegroundColor Red

        # Check if gpedit.msc exists
        if (Test-Path "$env:SystemRoot\System32\gpedit.msc") {
            Write-OutputToTextBox "Group Policy Editor is enabled on this system." -ForegroundColor Green
        } else {
            Write-OutputToTextBox "Group Policy Editor is not enabled on this system." -ForegroundColor Red

            # Ask the user for confirmation
            if (Ask-UserConfirmation "Do you want to install GPEdit.msc now?") {
                Write-OutputToTextBox "Installing GPEdit.msc group policy editor..." -ForegroundColor Yellow

                # Install Microsoft-Windows-GroupPolicy-ClientTools-Package
                Get-ChildItem "$env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~*.mum" | ForEach-Object {
                    DISM /Online /NoRestart /Add-Package:"$($_.FullName)"
                }

                # Install Microsoft-Windows-GroupPolicy-ClientExtensions-Package
                Get-ChildItem "$env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~*.mum" | ForEach-Object {
                    DISM /Online /NoRestart /Add-Package:"$($_.FullName)"
                }

                Write-OutputToTextBox "Group Policy Editor has been successfully installed!" -ForegroundColor Green
            } else {
                Write-OutputToTextBox "User chose not to install GPEdit.msc. Continuing with the script..." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-OutputToTextBox "An error occurred while enabling Group Policy Editor: $_" -ForegroundColor Red
    }
}

                "Add powershell as Admin to Windows X and rt click context menus" {
                                    try {
                      # Step 17 - Add powershell to Windows X Menu #########################################################################
#Step-Progress

   # Add Powershell on Windows X Menu
# $response = Read-Host "Do you want to add Powershell (Admin) to the Windows X Menu now? (Y/N)"

# Check the response
# From here ADD or REMOVE Y or N REQUIREMENTS as needed...
# if ($response -eq "Y" -or $response -eq "y") {
    Write-OutputToTextBox "Setting Powershell on the Windows X Menu now..." -ForegroundColor Yellow

    # Add registry value
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUsePowerShellOnWinX" -Value 0 -PropertyType DWORD -Force

    # Kill explorer.exe process
    Stop-Process -Name "explorer" -Force

    # Start explorer.exe
    Start-Process explorer.exe
# }
# elseif ($response -eq "N" -or $response -eq "n") {
        Write-OutputToTextBox "Continuing with next script block." -ForegroundColor Yellow
#   }

# Step 17-2 -Add Command on Windows Right click context menu##############################################################

#Step-Progress

# $response = Read-Host "Do you want to add Command (Admin) to the Windows Right Click Context Menu? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    Write-OutputToTextBox "Setting Command as Admin on the Windows Right Click Context Menu now..." -ForegroundColor Yellow
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
        Write-OutputToTextBox "Continuing with next script block." -ForegroundColor Yellow
#   }
   Write-OutputToTextBox ""

# An example of working and not working attempts to write to 'drive' and :HKCR
# Add Powershell to Windows right click menu

# Step 17-3 -Give user a choice first##############################################################################################

#Step-Progress

# $response = Read-Host "Do you want to add Open Powershell as (Admin) to the right click context menu now? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    Write-OutputToTextBox "Setting Powershell as Admin on the Windows Right Click Context Menu now..." -ForegroundColor Yellow

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
    Write-OutputToTextBox "Continuing to the next script block.."
    
# } else {
#    Write-OutputToTextBox "Invalid input. Please enter Y or N."
# }
Write-OutputToTextBox "Ready for more :-) " -ForegroundColor DarkYellow
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Add Advanced IT High Performance Power Plan" {
    try {
        # Step: Offer a choice to the user
        if (Ask-UserConfirmation "Do you want to add the Advanced IT - High Performance Power Plan? << Laptops Only, >> << Do not run on Towers Dude >>") {
            Write-OutputToTextBox "Importing Advanced IT High Performance Plan now..." -ForegroundColor Yellow

            # Define the folder path where power plans are stored
            $libsPath = "C:\Tech_Folder\Libs\power"

            Write-OutputToTextBox "Checking for power plans in $libsPath" -ForegroundColor Cyan

            # Check if the folder exists
            if (Test-Path $libsPath) {
                Write-OutputToTextBox "Import folder found." -ForegroundColor Green

                # Get all files in the folder
                $allFiles = Get-ChildItem -Path $libsPath

                # Check if there are any files in the folder
                if ($allFiles.Count -gt 0) {
                    Write-OutputToTextBox "Files available for import:" -ForegroundColor Cyan

                    # Loop through each file in the folder
                    foreach ($file in $allFiles) {
                        # Extract the name of the file
                        $fileName = $file.Name
                        Write-OutputToTextBox "Found file: $fileName" -ForegroundColor Yellow

                        # Ask the user if they want to import the specific file
                        if (Ask-UserConfirmation "Do you want to import '$fileName'?") {
                            Write-OutputToTextBox "Importing power plan from file: $fileName" -ForegroundColor Cyan

                            # Import the power plan using the appropriate cmdlet
                            Import-PowerPlan -FilePath $file.FullName
                            # Uncomment the line below if using `powercfg` instead:
                            # Powercfg -import "c:\Tech_Folder\Libs\power\$fileName"
                        } else {
                            Write-OutputToTextBox "Skipped importing: $fileName" -ForegroundColor Yellow
                        }
                    }
                } else {
                    Write-OutputToTextBox "No files found in the import folder." -ForegroundColor Red
                }
            } else {
                Write-OutputToTextBox "Import folder not found." -ForegroundColor Red
            }
        } else {
            Write-OutputToTextBox "User chose not to add the Advanced IT High Performance Power Plan. Continuing to the next script block..." -ForegroundColor Yellow
        }
    } catch {
        Write-OutputToTextBox "An error occurred while importing the power plan: $_" -ForegroundColor Red
    }
}


                "Add Kill all not responding tasks on right-click context menu" {
                #step 19 Kill all not responding tasks
                    try {
#step-progress
# $response = Read-Host "Do you want to add 'Kill all not responding tasks' to the desktop background right-click context menu now? (Y/N)"

# Check the response
# if ($response -eq "Y" -or $response -eq "y") {
    
    Step-Progress
    Write-OutputToTextBox "Adding 'Kill all not responding tasks' to the desktop background right-click context menu now..." -ForegroundColor Yellow

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
    
    Write-OutputToTextBox "The 'Kill all not responding tasks' has been added to the desktop background right-click context menu." -ForegroundColor Green
# } elseif ($response -eq "N" -or $response -eq "n") {
    Write-OutputToTextBox "Continuing to the next script block..."
# } else {
#   Write-OutputToTextBox "Invalid input. Please enter Y or N."
# }

Write-OutputToTextBox "Ready for more :-)" -ForegroundColor DarkYellow
Write-OutputToTextBox "We will be updating our script with more performance tweaks soon" -ForegroundColor Green

start-sleep 2
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Windows updates" {
    try {
        # Step 20 - Windows Updates ###########################################################

        # Function to get installed Windows updates
        function Get-InstalledUpdates {
            Write-OutputToTextBox "Fetching installed updates..." -ForegroundColor Cyan
            $installedUpdates = Get-HotFix
            $installedUpdates | Select-Object -Property Description, InstalledOn | Format-Table -AutoSize
        }

        # Function to get available Windows updates
        function Get-AvailableUpdates {
            Write-OutputToTextBox "Fetching available updates..." -ForegroundColor Cyan

            # Ensure Windows Update module is available
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Write-OutputToTextBox "PSWindowsUpdate module is not installed. Installing..." -ForegroundColor Yellow
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
            Write-OutputToTextBox "Downloading and installing updates..." -ForegroundColor Cyan

            # Ensure Windows Update module is available
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Write-OutputToTextBox "PSWindowsUpdate module is not installed. Installing..." -ForegroundColor Yellow
                Install-Module -Name PSWindowsUpdate -Scope CurrentUser -Force -AllowClobber
            }

            # Import the module
            Import-Module PSWindowsUpdate

            # Install updates
            Install-WindowsUpdate -AcceptAll -AutoReboot
        }

        # Main script
        function Main {
            Write-OutputToTextBox "=== Installed Updates ===" -ForegroundColor Green
            Get-InstalledUpdates

            Write-OutputToTextBox "`n=== Available Updates ===" -ForegroundColor Green
            Get-AvailableUpdates

            # Ask the user if they want to download and install updates
            if (Ask-UserConfirmation "Do you want to download and install the available updates now?") {
                Install-Updates
                Write-OutputToTextBox "Updates are being downloaded and installed." -ForegroundColor Green
            } else {
                Write-OutputToTextBox "Skipping updates installation." -ForegroundColor Yellow
            }
        }

        # Execute Main Function
        Main

    } catch {
        Write-OutputToTextBox "An error occurred while managing Windows updates: $_" -ForegroundColor Red
    }
}

                "Lock Windows 10 prevent 11 upgrade" {
                    try {
                      # Step 21 - Lock Windows 10 prevent 11 upgrade
#step-progress
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox "Preventing Windows 10 from upgrading to Windows 11" -ForegroundColor White

Write-OutputToTextBox "Setting WindowsUpdate TargetReleaseVersion to 22H2." -ForegroundColor Yellow
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

Write-Output "$WindowsUpdatePath -Name $TargetReleaseVersionName -Value $TargetReleaseVersionValue set accordingly."
Write-OutputToTextBox "Script Completed" -ForegroundColor Cyan

Write-OutputToTextBox "All Tasks Completed Successfully" -ForegroundColor Green
Start-Sleep -Seconds 2
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Advanced IT Deep Clean shortcut" {
                    try {
                     # step 22 create Advanced IT Deep Clean shortcut / create Tech_Folder / icon on user computer

#step-progress

Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/c /Sageset:65535 /Sagerun:65535" -NoNewWindow -Wait

# Define the target directory and icon source path
$targetDir = "C:\Tech_Folder"
$iconSourcePath = "C:\Tech_Folder\Libs\Icons\Win11_ico\Shell32_250.ico"
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

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
               "Settings tweak walkthrough" {
    try {
        # Step 23 - Settings tweak walkthrough #######################################################
        Write-OutputToTextBox "YOU ARE ALMOST THERE!!! - Now let's assist you with some OS-based front-end settings pages :-" -ForegroundColor Green

        # Function to open a specific settings page
        function Open-SettingsPage {
            param (
                [string]$SettingsUri,
                [string]$Message
            )
            
            Write-OutputToTextBox $Message
            Start-Process $SettingsUri
        }

        # Function to pause the script and wait for user confirmation
        function Wait-ForUserConfirmation {
            Write-OutputToTextBox "Please review the settings in the opened window." -ForegroundColor Cyan
            Write-OutputToTextBox "Once you have reviewed or made changes, confirm to continue..." -ForegroundColor Yellow
            
            # Wait for user confirmation
            if (Ask-UserConfirmation "Are you ready to continue?") {
                Write-OutputToTextBox "Continuing to the next settings tweak..." -ForegroundColor Green
            } else {
                Write-OutputToTextBox "Pausing until user is ready..." -ForegroundColor Red
                Wait-ForUserConfirmation
            }
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
            Open-SettingsPage -SettingsUri "ms-settings:notifications" -Message "Opening Notifications & Actions settings..."
            Wait-ForUserConfirmation

            # Open Taskbar Settings
            Open-SettingsPage -SettingsUri "ms-settings:taskbar" -Message "Opening Taskbar settings..."
            Wait-ForUserConfirmation

            # Open Game Mode Settings
            Open-SettingsPage -SettingsUri "ms-settings:gaming-gamebar" -Message "Opening Game Mode settings..."
            Wait-ForUserConfirmation

            Write-OutputToTextBox "All settings have been reviewed. Great work!" -ForegroundColor Green
        }

        # Run the main function of this section of code
        Main

    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Run troubleshooting packs with unattended answer files" {
                    try {
                        #step 32 - Run TroubleshootingPacks

# Set base directory path for troubleshooting packs
Clear
$basePath = "C:\Windows\diagnostics\system"  # Replace with actual path

# Set directory for storing answer files
$answerFileDirectory = "C:\AnswerFiles"

# Main menu loop
while ($true) {
    # Step 1: List all troubleshooting pack folders (subdirectories in the base path)
    $troubleshooterDirs = Get-ChildItem -Path $basePath -Directory

    # Step 2: Display the troubleshooting packs as a lettered menu
    Write-OutputToTextBox "`nSelect a troubleshooting pack:"
    $letters = @('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
    
    $counter = 0
    $troubleshooterDirs | ForEach-Object {
        Write-OutputToTextBox "$($letters[$counter]). $($_.Name)"
        $counter++
    }

    # Step 3: Display option to exit the script
    Write-OutputToTextBox "0. Exit"

    # Step 4: Read user input for selection (now letters)
    $selection = Read-Host "Enter the letter corresponding to the troubleshooting pack you want to use (0 to exit)"

    # Step 5: Check if the input is valid (either 0 to exit, or a valid letter from the list)
    if ($selection -eq 0) {
        Write-OutputToTextBox "Exiting script." -ForegroundColor Yellow
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
            Write-OutputToTextBox "`nThe answer file already exists for $($selectedPack.Name). What would you like to do?"
            Write-OutputToTextBox "1. Run the troubleshooter in unattended mode using the existing answer file."
            Write-OutputToTextBox "2. Create a new answer file and then run the troubleshooter in unattended mode."

            $choice = Read-Host "Enter your choice (1 to use existing, 2 to create new)"

            if ($choice -eq 1) {
                # Step 8: Run the troubleshooter in unattended mode using the existing answer file
                Write-OutputToTextBox "Running troubleshooting pack in unattended mode using the existing answer file: $($selectedPack.Name)" -ForegroundColor Cyan
                Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
                Write-OutputToTextBox "The troubleshooting process is complete." -ForegroundColor Green
            } elseif ($choice -eq 2) {
                # Step 9: Create a new answer file and run the troubleshooter in unattended mode
                Write-OutputToTextBox "Creating a new answer file and running the troubleshooting pack: $($selectedPack.Name)" -ForegroundColor Cyan
                Get-TroubleshootingPack $selectedPack.FullName -AnswerFile $answerFilePath
                Write-OutputToTextBox "Answer file created at: $answerFilePath"
                
                # Run the troubleshooter in unattended mode with the new answer file
                Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
                Write-OutputToTextBox "The troubleshooting process is complete." -ForegroundColor Green
            } else {
                Write-OutputToTextBox "Invalid choice. Please select 1 or 2." -ForegroundColor Red
            }
        } else {
            # If the answer file doesn't exist, create it and run the troubleshooter
            Write-OutputToTextBox "Answer file doesn't exist. Creating answer file and running troubleshooting pack: $($selectedPack.Name)" -ForegroundColor Cyan
            Get-TroubleshootingPack $selectedPack.FullName -AnswerFile $answerFilePath
            Write-OutputToTextBox "Answer file created at: $answerFilePath"

            # Step 9: Run the troubleshooter in unattended mode
            Get-TroubleshootingPack $selectedPack.FullName | Invoke-TroubleshootingPack -AnswerFile $answerFilePath
            Write-OutputToTextBox "The troubleshooting process is complete." -ForegroundColor Green
        }
    } else {
        # Handle invalid selection (if the user selects a letter that's out of range)
        Write-OutputToTextBox "Invalid selection! Please select a valid letter from the list (A to $($letters[$troubleshooterDirs.Count-1]), or 0 to exit)." -ForegroundColor Red
    }

    # Wait for user input to return to the main menu
    Write-OutputToTextBox "`nPress Enter to return to the main menu."
    Read-Host  # Wait for Enter key to continue
}

                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                }
                "Install WebApps" {
                    try {
                #step 24 - Install Web based applications

#Step-Progress

Write-OutputToTextBox "Web Apps are being installed, please wait until fully completed." -ForeGround Yellow
Write-OutputToTextBox "Your screen may flicker Black during this process..." -ForegroundColor DarkYellow
Start-Sleep 5
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox "Greasing the Lines..."
Write-OutputToTextBox "Lubing the spiders..."
Start-Sleep 2
# Get the drive letter of the script location if run from usb
#$scriptDrive = (Get-Item -Path $MyInvocation.MyCommand.Path).PSDrive.Root

# Define source and destination paths
#$sourcePath = Join-Path -Path $scriptDrive -ChildPath "Tech_Folder\Tech Scripts\Mal_Main\Current\Web Applications\Icons"

#$destinationPath = "C:\Tech_Folder\Libs\"

# Check if the destination path exists, if not, create it
#if (!(Test-Path -Path $destinationPath)) {
#    New-Item -Path $destinationPath -ItemType Directory
#}

# Copy the directories and files from the source to the destination with overwrite
#Write-OutputToTextBox "Copying files from '$sourcePath' to '$destinationPath'..."
#Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force -PassThru | ForEach-Object {
#    Write-OutputToTextBox "Copied: $($_.FullName)"
#}
#Write-OutputToTextBox "Copy operation completed."
clear

Write-OutputToTextBox "Web Apps are being installed, please wait until fully completed......." -ForeGround Yellow
Write-OutputToTextBox "Your screen may FLICKER BLACK during this process. Just chill Dude..." -ForegroundColor DarkYellow

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
    Write-OutputToTextBox "Installed: $($app.Name) from $($app.URL)" -ForegroundColor Cyan
    
    }


  # Close all Edge app windows
Stop-Process -Name "msedge" -Force

Start-Sleep 2 

# Run the Final message
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox "Tweak Settings completed, please reboot your computer"-ForegroundColor Blue
Write-OutputToTextBox ""
Write-OutputToTextBox "All operations completed successfully. Your system is now optimized for performance." -ForegroundColor White
Write-OutputToTextBox ""
Write-OutputToTextBox "Thank you for using Windows Tweak & Squeak Toolbox!" -ForegroundColor Cyan
Write-OutputToTextBox ""
Write-OutputToTextBox "....We will be adding more soon. MGM 21-2-25"

# Run out message - Mission Impossible

Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox ""
Write-OutputToTextBox "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-OutputToTextBox "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-OutputToTextBox "        Nothing is impossible ! Believe with all your heart and LIVE in the moment you SEE !!      " -ForegroundColor White
Write-OutputToTextBox "________________________________________________________________________________________________>>>" -ForegroundColor Green
Write-OutputToTextBox "________________________________________________________________________________________________>>>" -ForegroundColor Green
                    } catch {
                        Write-OutputToTextBox "Error: $_" "Red"
                    }
                  }
              }
          }
      }
  })

$panelRight.Controls.Add($outputTextBox)
$panelRight.Controls.Add($runButton)
$mainPanel.Panel2.Controls.Add($panelRight)

$form.Controls.Add($mainPanel)
$form.ShowDialog()
