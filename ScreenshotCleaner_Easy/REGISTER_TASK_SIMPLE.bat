@echo off
echo Creating scheduled task...
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1\"" /F
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Task created.
    echo.
    echo Next run time:
    schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST | findstr "Next"
) else (
    echo FAILED! Error: %ERRORLEVEL%
)
pause