# ScreenshotCleaner PowerShell Installer
# Right-click this file and select "Run with PowerShell"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ScreenshotCleaner Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This tool will DELETE screenshots at 9:00 AM daily" -ForegroundColor Yellow
Write-Host "WARNING: Deleted files CANNOT be recovered!" -ForegroundColor Red
Write-Host ""
Write-Host "Press Enter to continue or Ctrl+C to cancel..."
Read-Host

# Get current directory
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$installDir = "$env:LOCALAPPDATA\ScreenshotCleaner"

# Create directory
Write-Host "Creating directory..." -ForegroundColor Green
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

# Copy files
Write-Host "Copying files..." -ForegroundColor Green
Copy-Item "$currentDir\clean_screenshots.ps1" "$installDir\" -Force
Copy-Item "$currentDir\test.bat" "$installDir\" -Force
Copy-Item "$currentDir\status.bat" "$installDir\" -Force
Copy-Item "$currentDir\uninstall.bat" "$installDir\" -Force

# Create scheduled task
Write-Host "Creating scheduled task..." -ForegroundColor Green
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installDir\clean_screenshots.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At 9:00AM
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

try {
    Unregister-ScheduledTask -TaskName "ScreenshotCleaner9AM" -Confirm:$false -ErrorAction SilentlyContinue
    Register-ScheduledTask -TaskName "ScreenshotCleaner9AM" -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Installation Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Screenshots will be deleted at 9:00 AM daily" -ForegroundColor Cyan
    Write-Host ""
    
    # Ask for test
    $test = Read-Host "Test now? (Y/N)"
    if ($test -eq 'Y' -or $test -eq 'y') {
        Write-Host ""
        Write-Host "Test mode (no files deleted):" -ForegroundColor Yellow
        Write-Host "------------------------------" -ForegroundColor Yellow
        & powershell -ExecutionPolicy Bypass -File "$installDir\clean_screenshots.ps1" -WhatIf
        Write-Host "------------------------------" -ForegroundColor Yellow
        Write-Host "These files will be deleted at 9:00 AM" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR: Failed to create task" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running as Administrator" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Tools location: $installDir" -ForegroundColor Gray
Write-Host "  test.bat - Test deletion" -ForegroundColor Gray
Write-Host "  status.bat - Check status" -ForegroundColor Gray
Write-Host "  uninstall.bat - Remove tool" -ForegroundColor Gray
Write-Host ""
Write-Host "Press Enter to exit..."
Read-Host