@echo off
cls
echo =======================================
echo   Step 2 - Schedule Setup
echo =======================================
echo.
echo Creating task for 9:00 AM daily...
echo.

schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Task created.
    echo.
    for /f "tokens=*" %%a in ('schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST ^| findstr /C:"Next Run Time"') do echo %%a
    echo.
    echo Setup complete!
) else (
    echo FAILED!
    echo Try: Run as administrator
)

echo.
pause