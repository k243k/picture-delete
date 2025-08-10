@echo off
title Install ScreenshotCleaner - 9:00 AM
cls
echo ========================================
echo   ScreenshotCleaner - 9:00 AM Version
echo ========================================
echo.
echo This will delete screenshots at 9:00 AM daily
echo.
pause

echo.
echo Installing...

set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%\logs" mkdir "%INSTALL_DIR%\logs"

echo Creating script...
(
echo param([switch]$WhatIf^)
echo.
echo Write-Host "===== ScreenshotCleaner Start =====" -ForegroundColor Cyan
echo if ^($WhatIf^) { Write-Host "TEST MODE - No files will be deleted" -ForegroundColor Yellow }
echo.
echo $username = [System.Environment]::UserName
echo $basePath = "C:\Users\$username"
echo $folders = @^(^)
echo.
echo $screenshotsPath = "$basePath\Pictures\Screenshots"
echo if ^(Test-Path $screenshotsPath^) { $folders += $screenshotsPath }
echo.
echo $capturesPath = "$basePath\Videos\Captures"
echo if ^(Test-Path $capturesPath^) { $folders += $capturesPath }
echo.
echo $desktopPath = "$basePath\Desktop"
echo $folders += $desktopPath
echo.
echo $allFiles = @^(^)
echo foreach ^($folder in $folders^) {
echo     if ^($folder -eq $desktopPath^) {
echo         $files = Get-ChildItem -Path $folder -Filter "Screenshot*.png" -File -ErrorAction SilentlyContinue
echo         if ^($files^) { $allFiles += $files }
echo         $files = Get-ChildItem -Path $folder -Filter "Screenshot*.jpg" -File -ErrorAction SilentlyContinue
echo         if ^($files^) { $allFiles += $files }
echo     } else {
echo         $exts = @^("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp"^)
echo         foreach ^($ext in $exts^) {
echo             $files = Get-ChildItem -Path $folder -Filter $ext -Recurse -File -ErrorAction SilentlyContinue
echo             if ^($files^) { $allFiles += $files }
echo         }
echo     }
echo }
echo.
echo Write-Host "Found $^($allFiles.Count^) files" -ForegroundColor Cyan
echo if ^($allFiles.Count -eq 0^) { 
echo     Write-Host "No screenshots found" -ForegroundColor Yellow
echo     exit 0
echo }
echo.
echo $successCount = 0
echo foreach ^($file in $allFiles^) {
echo     try {
echo         if ^($WhatIf^) {
echo             Write-Host "[TEST] Would delete: $^($file.FullName^)" -ForegroundColor Yellow
echo         } else {
echo             Remove-Item -Path $file.FullName -Force -ErrorAction Stop
echo             Write-Host "[DELETED] $^($file.FullName^)" -ForegroundColor Green
echo         }
echo         $successCount++
echo     } catch {
echo         Write-Host "[ERROR] $_" -ForegroundColor Red
echo     }
echo }
echo Write-Host "Complete: $successCount / $^($allFiles.Count^) files" -ForegroundColor Cyan
) > "%INSTALL_DIR%\clean_screenshots.ps1"

echo.
echo Creating scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    cls
    echo ========================================
    echo   Installation Complete!
    echo ========================================
    echo.
    echo Screenshots will be deleted at 9:00 AM daily
    echo.
    echo Test now? (Y/N)
    choice /C YN /N /M "Select: "
    
    if %ERRORLEVEL% EQU 1 (
        echo.
        echo Testing...
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo These files will be deleted at 9:00 AM
    )
) else (
    echo ERROR: Failed to create task
    echo Try running as Administrator
)

echo.
pause