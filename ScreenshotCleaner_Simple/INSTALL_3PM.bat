@echo off
title Install ScreenshotCleaner - 3:00 PM
cls
echo ========================================
echo   ScreenshotCleaner - 3:00 PM Version
echo ========================================
echo.
echo This will delete screenshots at 3:00 PM daily
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
schtasks /Delete /TN "ScreenshotCleaner3PM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 15:00 /TN "ScreenshotCleaner3PM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    cls
    echo ========================================
    echo   Installation Complete!
    echo ========================================
    echo.
    echo Screenshots will be deleted at 3:00 PM daily
    echo.
    echo Test now? (Y/N)
    choice /C YN /N /M "Select: "
    
    if %ERRORLEVEL% EQU 1 (
        echo.
        echo Testing...
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo These files will be deleted at 3:00 PM
    )
) else (
    echo ERROR: Failed to create task
    echo Try running as Administrator
)

echo.
pause