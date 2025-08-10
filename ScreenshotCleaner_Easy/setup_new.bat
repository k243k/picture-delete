@echo off
setlocal enabledelayedexpansion
title ScreenshotCleaner Setup
cls

echo ========================================
echo   ScreenshotCleaner Simple Setup
echo ========================================
echo.
echo This will set up automatic screenshot deletion.
echo Screenshots will be deleted at 9:00 AM daily.
echo.
echo Press any key to continue...
pause >nul

cls
echo ========================================
echo   Installing...
echo ========================================
echo.

REM Check if script exists
if not exist "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" (
    echo [1/3] Copying files...
    if not exist "%LOCALAPPDATA%\ScreenshotCleaner" (
        mkdir "%LOCALAPPDATA%\ScreenshotCleaner"
    )
    copy /Y "%~dp0clean_screenshots_fixed.ps1" "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo       OK - Files copied
    ) else (
        echo       FAILED - Cannot copy files
        echo       Please run FIX_NOW.bat first
        pause
        exit /b 1
    )
) else (
    echo [1/3] Files already exist - OK
)

echo.
echo [2/3] Removing old task if exists...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
echo       OK - Ready for new task

echo.
echo [3/3] Creating scheduled task...
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1\"" /F >nul 2>&1

if !ERRORLEVEL! EQU 0 (
    cls
    echo ========================================
    echo   SUCCESS!
    echo ========================================
    echo.
    echo Installation complete!
    echo Screenshots will be deleted at 9:00 AM daily.
    echo.
    echo Task details:
    for /f "tokens=*" %%a in ('schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST ^| findstr /C:"Next Run Time"') do echo   %%a
    echo.
    echo ========================================
    echo.
    echo Test the script now? (Y/N)
    choice /C YN /N /M "Select: "
    
    if !ERRORLEVEL! EQU 1 (
        cls
        echo ========================================
        echo   Testing (no files will be deleted)
        echo ========================================
        echo.
        powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" -WhatIf
        echo.
        echo ========================================
        echo Test complete!
        echo These files will be deleted at 9:00 AM.
        echo ========================================
    )
) else (
    echo       FAILED!
    echo.
    echo Please try running as Administrator:
    echo 1. Right-click this file
    echo 2. Select "Run as administrator"
)

echo.
echo Press any key to exit...
pause >nul