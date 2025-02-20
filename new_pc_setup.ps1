# Ensure Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed or not in the PATH. Please install Winget first." -ForegroundColor Red
    exit 1
}

# WiFi Setup Variables
$wifiName = "Skylinks_ProShop"   # Replace with the actual WiFi SSID
$wifiPassword = "1091ConcordAvenue"  # Replace with the actual WiFi password

Write-Host "Setting up WiFi connection..."
netsh wlan add profile filename="WiFiProfile.xml"

# Create the WiFi profile XML content
$wifiProfile = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$wifiName</name>
    <SSIDConfig>
        <SSID>
            <name>$wifiName</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$wifiPassword</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@

# Save the WiFi profile XML file
$wifiProfilePath = "$env:TEMP\WiFiProfile.xml"
$wifiProfile | Set-Content -Path $wifiProfilePath -Encoding UTF8

# Add the WiFi profile to the system
netsh wlan add profile filename="$wifiProfilePath"

# Connect to the WiFi
netsh wlan connect name="$wifiName"

Write-Host "WiFi setup complete!" -ForegroundColor Green

# Install required applications
$apps = @(
    "Google.Chrome",
    "Epson.SmartScan",
    "SlackTechnologies.Slack",
    "StarMicronics.StarPrinterUtility",
    "NerdFonts.NerdFonts"
)

foreach ($app in $apps) {
    Write-Host "Installing $app..."
    Start-Process -NoNewWindow -Wait -FilePath "winget" -ArgumentList "install --id=$app --silent --accept-source-agreements --accept-package-agreements"
}

Write-Host "All applications installed successfully!" -ForegroundColor Green

# Configure power settings: Never turn off display and never go to sleep
Write-Host "Configuring power settings..."
powercfg /change monitor-timeout-ac 0  # Never turn off screen on AC power
powercfg /change monitor-timeout-dc 0  # Never turn off screen on battery
powercfg /change standby-timeout-ac 0  # Never go to sleep on AC power
powercfg /change standby-timeout-dc 0  # Never go to sleep on battery

Write-Host "Power settings configured successfully!" -ForegroundColor Green

Write-Host "Setup complete! Restart the computer for all changes to take effect." -ForegroundColor Cyan
