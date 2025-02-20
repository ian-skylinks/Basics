# Ensure Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget is not installed or not in the PATH. Please install Winget first." -ForegroundColor Red
    exit 1
}

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
