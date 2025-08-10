@echo off
title Test Screenshot Deletion
cls

echo =======================================
echo   Test Mode
echo =======================================
echo.
echo 1 = Check what will be deleted (safe)
echo 2 = Delete now (permanent!)
echo 3 = Exit
echo.
choice /C 123 /N /M "Select: "

if %ERRORLEVEL% EQU 1 (
    cls
    echo =======================================
    echo   Test Mode - No deletion
    echo =======================================
    echo.
    powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" -WhatIf
    echo.
    echo =======================================
    echo These files will be deleted at 9:00 AM
    echo =======================================
    pause
)

if %ERRORLEVEL% EQU 2 (
    cls
    echo =======================================
    echo   WARNING!
    echo =======================================
    echo.
    echo Delete all screenshots NOW?
    echo This cannot be undone!
    echo.
    echo Y = Delete
    echo N = Cancel
    echo.
    choice /C YN /N /M "Select: "
    
    if %ERRORLEVEL% EQU 1 (
        cls
        echo Deleting...
        echo.
        powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1"
        echo.
        echo Done!
        pause
    )
)