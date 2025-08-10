@echo off
title Check ScreenshotCleaner Status
cls
echo ========================================
echo   ScreenshotCleaner Status Check
echo ========================================
echo.

echo Checking for scheduled tasks...
echo.

:: Check 9AM task
echo [9:00 AM Task]
schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Status: NOT INSTALLED
) 
echo.

:: Check 3AM task
echo [3:00 AM Task]
schtasks /Query /TN "ScreenshotCleaner3AM" /FO LIST 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Status: NOT INSTALLED
)
echo.

:: Check 3PM task
echo [3:00 PM Task]
schtasks /Query /TN "ScreenshotCleaner3PM" /FO LIST 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Status: NOT INSTALLED
)

echo.
echo ========================================
echo   Quick Commands:
echo ========================================
echo.
echo Change time to 3:00 AM:
echo   schtasks /Change /TN "ScreenshotCleaner9AM" /ST 03:00
echo.
echo Change time to 3:00 PM:
echo   schtasks /Change /TN "ScreenshotCleaner9AM" /ST 15:00
echo.
echo Run now (manual test):
echo   schtasks /Run /TN "ScreenshotCleaner9AM"
echo.
echo ========================================
echo.
pause