@echo off
title Install ScreenshotCleaner - 9:00 AM (Run as Admin)

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ========================================
    echo   Administrator Rights Required
    echo ========================================
    echo.
    echo Please right-click this file and select
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

cls
echo ========================================
echo   ScreenshotCleaner - 9:00 AM Version
echo   (Administrator Mode)
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
echo Creating scheduled task with SYSTEM privileges...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /RU SYSTEM /F

set TASK_RESULT=%ERRORLEVEL%

if %TASK_RESULT% EQU 0 (
    cls
    echo ========================================
    echo   Installation Complete!
    echo ========================================
    echo.
    echo Screenshots will be deleted at 9:00 AM daily
    echo Running with SYSTEM privileges
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
    echo To verify the task was created:
    echo Run: schtasks /Query /TN "ScreenshotCleaner9AM"
) else (
    echo.
    echo ERROR: Failed to create task (Error code: %TASK_RESULT%)
    echo Please ensure you have administrator rights
)

echo.
pause