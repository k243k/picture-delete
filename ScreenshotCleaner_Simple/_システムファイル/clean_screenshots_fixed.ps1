# ScreenshotCleaner - Fixed Version (No Environment Variables)
param([switch]$WhatIf)

Write-Host "===== ScreenshotCleaner Start =====" -ForegroundColor Cyan
if ($WhatIf) { 
    Write-Host "TEST MODE - No files will be deleted" -ForegroundColor Yellow
}

# Get username directly
$username = [System.Environment]::UserName
if (-not $username) {
    $username = (Get-WmiObject -Class Win32_ComputerSystem).UserName.Split('\')[1]
}

Write-Host "User: $username" -ForegroundColor Gray

# Build paths manually
$basePath = "C:\Users\$username"
$screenshotsPath = "$basePath\Pictures\Screenshots"
$capturesPath = "$basePath\Videos\Captures"
$desktopPath = "$basePath\Desktop"

Write-Host "Checking folders..." -ForegroundColor Gray

# Check each folder
$folders = @()
if (Test-Path $screenshotsPath) {
    $folders += $screenshotsPath
    Write-Host "  Found: Screenshots folder" -ForegroundColor Green
}
if (Test-Path $capturesPath) {
    $folders += $capturesPath
    Write-Host "  Found: Captures folder" -ForegroundColor Green
}
if (Test-Path $desktopPath) {
    $folders += $desktopPath
    Write-Host "  Found: Desktop" -ForegroundColor Green
}

# Find files
Write-Host "Searching for screenshots..." -ForegroundColor Gray
$allFiles = @()

foreach ($folder in $folders) {
    if ($folder -eq $desktopPath) {
        # Desktop - only Screenshot files
        try {
            $files = Get-ChildItem -Path $folder -Filter "Screenshot*.png" -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
            $files = Get-ChildItem -Path $folder -Filter "Screenshot*.jpg" -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
            $files = Get-ChildItem -Path $folder -Filter "スクリーンショット*.png" -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
            $files = Get-ChildItem -Path $folder -Filter "スクリーンショット*.jpg" -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
        } catch {
            Write-Host "  Error reading Desktop: $_" -ForegroundColor Red
        }
    } else {
        # Screenshots and Captures folders - all images
        try {
            $extensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp")
            foreach ($ext in $extensions) {
                $files = Get-ChildItem -Path $folder -Filter $ext -Recurse -File -ErrorAction SilentlyContinue
                if ($files) { $allFiles += $files }
            }
        } catch {
            Write-Host "  Error reading $folder : $_" -ForegroundColor Red
        }
    }
}

$totalCount = $allFiles.Count
Write-Host "Found $totalCount screenshot(s)" -ForegroundColor Cyan

if ($totalCount -eq 0) {
    Write-Host "No screenshots found to delete" -ForegroundColor Yellow
    Write-Host "===== ScreenshotCleaner End =====" -ForegroundColor Cyan
    exit 0
}

# Delete or show files
$successCount = 0
$failCount = 0

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
        Write-Host "[ERROR] Cannot delete: $($file.FullName) - $_" -ForegroundColor Red
        $failCount++
    }
}

# Summary
Write-Host "===== Summary =====" -ForegroundColor Cyan
if ($WhatIf) {
    Write-Host "TEST COMPLETE: Would delete $successCount file(s)" -ForegroundColor Yellow
} else {
    Write-Host "Deleted: $successCount file(s)" -ForegroundColor Green
    if ($failCount -gt 0) {
        Write-Host "Failed: $failCount file(s)" -ForegroundColor Red
    }
}
Write-Host "===== ScreenshotCleaner End =====" -ForegroundColor Cyan