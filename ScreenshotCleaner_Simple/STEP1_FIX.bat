@echo off
cls
echo =======================================
echo   Step 1 - Fix Script
echo =======================================
echo.

set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Copying fixed script...

REM Try multiple locations for the file
if exist "%~dp0_システムファイル\clean_screenshots_fixed.ps1" (
    copy /Y "%~dp0_システムファイル\clean_screenshots_fixed.ps1" "%INSTALL_DIR%\clean_screenshots.ps1"
    goto :check
)

if exist "%~dp0clean_screenshots_fixed.ps1" (
    copy /Y "%~dp0clean_screenshots_fixed.ps1" "%INSTALL_DIR%\clean_screenshots.ps1"
    goto :check
)

if exist "%~dp0..\old\ScreenshotCleaner_Easy\clean_screenshots_fixed.ps1" (
    copy /Y "%~dp0..\old\ScreenshotCleaner_Easy\clean_screenshots_fixed.ps1" "%INSTALL_DIR%\clean_screenshots.ps1"
    goto :check
)

echo ERROR: Cannot find clean_screenshots_fixed.ps1
echo.
echo Please use old version:
echo _old\ScreenshotCleaner_Easy\FIX_NOW.bat
echo.
pause
exit /b 1

:check
if exist "%INSTALL_DIR%\clean_screenshots.ps1" (
    echo SUCCESS! Files copied.
    echo.
    echo Testing...
    powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
    echo.
    echo If you see files above, it worked!
    echo Next: Run STEP2_SETUP.bat
) else (
    echo ERROR: Copy failed
)

echo.
pause