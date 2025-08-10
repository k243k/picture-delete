@echo off
title Step 2 - Schedule Setup
cls

echo =======================================
echo   Step 2: Setting up daily schedule
echo =======================================
echo.
echo Will delete screenshots at 9:00 AM daily
echo.
pause

echo.
echo Creating scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    cls
    echo =======================================
    echo   COMPLETE!
    echo =======================================
    echo.
    echo Setup finished successfully!
    echo.
    echo Screenshots will be deleted:
    echo   - Every day at 9:00 AM
    echo   - From Pictures\Screenshots
    echo   - From Videos\Captures
    echo   - From Desktop (Screenshot*.png/jpg)
    echo.
    echo =======================================
    echo.
    for /f "tokens=*" %%a in ('schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST ^| findstr /C:"Next Run Time"') do echo %%a
    echo.
) else (
    echo.
    echo ERROR: Could not create task.
    echo.
    echo Try: Right-click and "Run as administrator"
)

echo.
pause