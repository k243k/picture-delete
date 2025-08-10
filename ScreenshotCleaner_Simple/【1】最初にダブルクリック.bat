@echo off
title Step 1 - Fix Script
cls

echo =======================================
echo   Step 1: Fixing script files
echo =======================================
echo.

set SYSTEM_DIR=%~dp0_システムファイル
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner

echo Checking files...

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" >nul 2>&1
)

echo Copying fixed version...
copy /Y "%SYSTEM_DIR%\clean_screenshots_fixed.ps1" "%INSTALL_DIR%\clean_screenshots.ps1" >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =======================================
    echo   SUCCESS! Files are ready.
    echo =======================================
    echo.
    echo Testing...
    echo.
    powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
    echo.
    echo =======================================
    echo If you see files above, it worked!
    echo.
    echo Next: Run [2] 
    echo =======================================
) else (
    echo.
    echo ERROR: Could not copy files.
    echo Please check if files exist.
)

echo.
pause