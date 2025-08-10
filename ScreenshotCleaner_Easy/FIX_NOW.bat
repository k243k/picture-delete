@echo off
echo ========================================
echo   Fixing ScreenshotCleaner
echo ========================================
echo.
echo This will replace the broken script with a working version.
echo.
pause

echo Copying fixed version...
copy /Y "%~dp0clean_screenshots_fixed.ps1" "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS! Script has been fixed.
    echo.
    echo Testing the fixed version...
    echo ========================================
    powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" -WhatIf
    echo ========================================
    echo.
    echo If you see files listed above, the fix worked!
) else (
    echo.
    echo FAILED to copy file.
    echo Trying manual fix...
    echo.
    echo Please run this PowerShell command:
    echo.
    echo powershell -ExecutionPolicy Bypass -File "%~dp0clean_screenshots_fixed.ps1" -WhatIf
)

echo.
pause