@echo off
title Install ScreenshotCleaner - 3:00 AM
cls
echo ========================================
echo   ScreenshotCleaner - 3:00 AM Version
echo ========================================
echo.
echo This will delete screenshots at 3:00 AM daily
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
schtasks /Delete /TN "ScreenshotCleaner3AM" /F >nul 2>&1
schtasks /Create /SC DAILY /ST 03:00 /TN "ScreenshotCleaner3AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F

set TASK_RESULT=%ERRORLEVEL%

if %TASK_RESULT% EQU 0 (
    cls
    echo ========================================
    echo   Installation Complete!
    echo ========================================
    echo.
    echo Screenshots will be deleted at 3:00 AM daily
    echo.
    echo Test now? (Y/N)
    choice /C YN /N /M "Select: "
    
    if ERRORLEVEL 2 (
        echo.
        echo Setup complete. Task will run at 3:00 AM.
    ) else (
        echo.
        echo Testing...
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo These files will be deleted at 3:00 AM
    )
) else (
    echo.
    echo ERROR: Failed to create task
    echo Try running as Administrator
)

echo.
pause