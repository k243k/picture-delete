# ScreenshotCleaner Installer - All in One
# Right-click this file and select "Run with PowerShell"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ScreenshotCleaner Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will delete screenshots at 9:00 AM daily" -ForegroundColor Yellow
Write-Host "WARNING: Files cannot be recovered!" -ForegroundColor Red
Write-Host ""
Write-Host "Press Enter to continue or Ctrl+C to cancel..."
Read-Host

# Create installation directory
$installDir = "$env:LOCALAPPDATA\ScreenshotCleaner"
Write-Host "Creating directory..." -ForegroundColor Green
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
New-Item -ItemType Directory -Path "$installDir\logs" -Force | Out-Null

# Create the main script
Write-Host "Creating script..." -ForegroundColor Green
$scriptContent = @'
param([switch]$WhatIf)

Write-Host "===== ScreenshotCleaner Start =====" -ForegroundColor Cyan
if ($WhatIf) { 
    Write-Host "TEST MODE - No files will be deleted" -ForegroundColor Yellow
}

$username = [System.Environment]::UserName
$basePath = "C:\Users\$username"
$folders = @()

$screenshotsPath = "$basePath\Pictures\Screenshots"
if (Test-Path $screenshotsPath) {
    $folders += $screenshotsPath
    Write-Host "Found: Screenshots folder" -ForegroundColor Green
}

$capturesPath = "$basePath\Videos\Captures"
if (Test-Path $capturesPath) {
    $folders += $capturesPath
    Write-Host "Found: Captures folder" -ForegroundColor Green
}

$desktopPath = "$basePath\Desktop"
$folders += $desktopPath
Write-Host "Found: Desktop" -ForegroundColor Green

Write-Host "Searching for screenshots..." -ForegroundColor Gray
$allFiles = @()

foreach ($folder in $folders) {
    if ($folder -eq $desktopPath) {
        $patterns = @("Screenshot*.png", "Screenshot*.jpg")
        foreach ($pattern in $patterns) {
            $files = Get-ChildItem -Path $folder -Filter $pattern -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
        }
    } else {
        $extensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp")
        foreach ($ext in $extensions) {
            $files = Get-ChildItem -Path $folder -Filter $ext -Recurse -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
        }
    }
}

$totalCount = $allFiles.Count
Write-Host "Found $totalCount screenshot(s)" -ForegroundColor Cyan

if ($totalCount -eq 0) {
    Write-Host "No screenshots found" -ForegroundColor Yellow
    exit 0
}

$successCount = 0
foreach ($file in $allFiles) {
    try {
        if ($WhatIf) {
            Write-Host "[TEST] Would delete: $($file.FullName)" -ForegroundColor Yellow
            $successCount++
        } else {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            Write-Host "[DELETED] $($file.FullName)" -ForegroundColor Green
            $successCount++
        }
    } catch {
        Write-Host "[ERROR] $($file.FullName) - $_" -ForegroundColor Red
    }
}

Write-Host "===== Complete: $successCount / $totalCount files =====" -ForegroundColor Cyan
'@

$scriptContent | Out-File -FilePath "$installDir\clean_screenshots.ps1" -Encoding UTF8
Write-Host "Script created successfully" -ForegroundColor Green

# Test the script
Write-Host ""
Write-Host "Testing script..." -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray
& powershell -ExecutionPolicy Bypass -File "$installDir\clean_screenshots.ps1" -WhatIf
Write-Host "----------------------------------------" -ForegroundColor Gray

# Create scheduled task
Write-Host ""
Write-Host "Creating scheduled task..." -ForegroundColor Green

# Remove old task if exists
$null = schtasks /Delete /TN "ScreenshotCleaner9AM" /F 2>$null

# Create new task using schtasks (more reliable)
$taskResult = schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installDir\clean_screenshots.ps1`"" /F 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Installation Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Screenshots will be deleted at 9:00 AM daily" -ForegroundColor Cyan
    Write-Host ""
    
    # Show next run time
    $taskInfo = schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST | Select-String "Next Run Time"
    if ($taskInfo) {
        Write-Host $taskInfo -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "To change time, run this command:" -ForegroundColor Gray
    Write-Host 'schtasks /Change /TN "ScreenshotCleaner9AM" /ST 15:00' -ForegroundColor White
    Write-Host "(Example: 15:00 = 3:00 PM)" -ForegroundColor Gray
    
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to create scheduled task" -ForegroundColor Red
    Write-Host "Try running this script as Administrator" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "To uninstall, run this command:" -ForegroundColor Gray
Write-Host 'schtasks /Delete /TN "ScreenshotCleaner9AM" /F' -ForegroundColor White
Write-Host 'Remove-Item -Path "$env:LOCALAPPDATA\ScreenshotCleaner" -Recurse -Force' -ForegroundColor White

Write-Host ""
Write-Host "Press Enter to exit..."
Read-Host