param([switch]$WhatIf)

Write-Host "===== ScreenshotCleaner Start =====" -ForegroundColor Cyan
if ($WhatIf) { 
    Write-Host "TEST MODE - No files will be deleted" -ForegroundColor Yellow 
}

# Get username and set base path
$username = [System.Environment]::UserName
$basePath = "C:\Users\$username"

# Initialize folders array
$folders = @()

# Check and add Screenshots folder
$screenshotsPath = "$basePath\Pictures\Screenshots"
if (Test-Path $screenshotsPath) { 
    $folders += $screenshotsPath 
    Write-Host "Checking: $screenshotsPath" -ForegroundColor Gray
}

# Check and add Captures folder
$capturesPath = "$basePath\Videos\Captures"
if (Test-Path $capturesPath) { 
    $folders += $capturesPath 
    Write-Host "Checking: $capturesPath" -ForegroundColor Gray
}

# Always check Desktop
$desktopPath = "$basePath\Desktop"
$folders += $desktopPath
Write-Host "Checking: $desktopPath (Screenshot*.png/jpg only)" -ForegroundColor Gray

# Collect all files
$allFiles = @()
foreach ($folder in $folders) {
    if ($folder -eq $desktopPath) {
        # Desktop: Screenshot*.png/jpg only
        $files = Get-ChildItem -Path $folder -Filter "Screenshot*.png" -File -ErrorAction SilentlyContinue
        if ($files) { $allFiles += $files }
        $files = Get-ChildItem -Path $folder -Filter "Screenshot*.jpg" -File -ErrorAction SilentlyContinue
        if ($files) { $allFiles += $files }
    } else {
        # Other folders: all image files
        $exts = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp")
        foreach ($ext in $exts) {
            $files = Get-ChildItem -Path $folder -Filter $ext -Recurse -File -ErrorAction SilentlyContinue
            if ($files) { $allFiles += $files }
        }
    }
}

Write-Host ""
Write-Host "Found $($allFiles.Count) screenshot(s)" -ForegroundColor Cyan

if ($allFiles.Count -eq 0) { 
    Write-Host "No screenshots found" -ForegroundColor Yellow
    exit 0
}

# Delete files
$successCount = 0
foreach ($file in $allFiles) {
    try {
        if ($WhatIf) {
            Write-Host "[TEST] Would delete: $($file.FullName)" -ForegroundColor Yellow
        } else {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            Write-Host "[DELETED] $($file.FullName)" -ForegroundColor Green
        }
        $successCount++
    } catch {
        Write-Host "[ERROR] $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Complete: $successCount / $($allFiles.Count) files" -ForegroundColor Cyan