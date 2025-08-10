@echo off
setlocal enabledelayedexpansion
title ScreenshotCleaner Test

echo ========================================
echo   ScreenshotCleaner Test
echo ========================================
echo.

set SCRIPT=%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1

if not exist "%SCRIPT%" (
    echo ERROR: Not installed yet
    echo Please run setup.bat first
    pause
    exit /b 1
)

echo 1. Test mode (no deletion)
echo 2. Delete now (PERMANENT!)
echo 3. Exit
echo.
choice /C 123 /N /M "Select (1-3): "

if !ERRORLEVEL! EQU 1 (
    echo.
    echo Running test...
    echo.
    powershell -ExecutionPolicy Bypass -File "%SCRIPT%" -WhatIf
    echo.
    pause
)

if !ERRORLEVEL! EQU 2 (
    echo.
    echo WARNING: Delete all screenshots now? (Y/N)
    choice /C YN /N
    if !ERRORLEVEL! EQU 1 (
        echo.
        echo Deleting...
        echo.
        powershell -ExecutionPolicy Bypass -File "%SCRIPT%"
        echo.
        pause
    )
)