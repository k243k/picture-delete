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

echo Copying script...
copy /Y "%~dp0clean_screenshots.ps1" "%INSTALL_DIR%\clean_screenshots.ps1" >nul

echo.
echo Creating scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    goto :SUCCESS
) else (
    goto :ERROR
)

:SUCCESS
cls
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo Screenshots will be deleted at 9:00 AM daily
echo.
echo Test now? (Y/N)
choice /C YN /N /M "Select: "

if ERRORLEVEL 2 (
    echo.
    echo Setup complete. Task will run at 9:00 AM.
) else (
    echo.
    echo Testing...
    echo.
    powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
    echo.
    echo These files will be deleted at 9:00 AM
)
echo.
pause
exit /b 0

:ERROR
echo.
echo ERROR: Failed to create task
echo Try running as Administrator
echo.
pause
exit /b 1