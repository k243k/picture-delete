@echo off
setlocal enabledelayedexpansion
title ScreenshotCleaner Setup
color 0E

cls
echo ========================================
echo   ScreenshotCleaner Easy Setup
echo ========================================
echo.
echo This tool will DELETE your screenshots
echo automatically at 9:00 AM every day.
echo.
echo WARNING: Deleted files CANNOT be recovered!
echo.
echo Press any key to start setup...
pause >nul

cls
echo ========================================
echo   Installing...
echo ========================================
echo.

REM Get current directory
set CURRENT_DIR=%~dp0
set CURRENT_DIR=%CURRENT_DIR:~0,-1%

REM Install directory
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner

REM Step 1: Create folder
echo [1/4] Creating folder...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo     FAILED: Cannot create folder
        echo     Error code: !ERRORLEVEL!
        pause
        exit /b 1
    )
)
echo     OK

REM Step 2: Copy files
echo [2/4] Copying files...
set COPY_ERROR=0

copy /Y "%CURRENT_DIR%\clean_screenshots.ps1" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\test.bat" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\uninstall.bat" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\status.bat" "%INSTALL_DIR%\" >nul 2>&1

if !COPY_ERROR! EQU 0 (
    echo     OK
) else (
    echo     FAILED: Cannot copy files
    echo     Current folder: %CURRENT_DIR%
    pause
    exit /b 1
)

REM Step 3: Remove old task
echo [3/4] Cleaning old settings...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
echo     OK

REM Step 4: Create task
echo [4/4] Creating scheduled task...
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F >nul 2>&1

if !ERRORLEVEL! EQU 0 (
    echo     OK
    echo.
    color 0A
    echo ========================================
    echo   Setup Complete!
    echo ========================================
    echo.
    echo Settings:
    echo   Run time: Every day at 9:00 AM
    echo   Location: %INSTALL_DIR%
    echo.
    echo ----------------------------------------
    echo.
    echo Test now? (Check which files will be deleted)
    echo.
    echo   Y = Test (recommended)
    echo   N = Exit
    echo.
    choice /C YN /N /M "Select (Y/N): "
    
    if !ERRORLEVEL! EQU 1 (
        cls
        echo ========================================
        echo   Test Mode (No files deleted)
        echo ========================================
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo ========================================
        echo   Test Complete
        echo ========================================
        echo.
        echo These files will be deleted at 9:00 AM daily.
        echo.
    )
) else (
    color 0C
    echo     FAILED
    echo.
    echo ========================================
    echo   Error
    echo ========================================
    echo.
    echo Failed to create scheduled task.
    echo Error code: !ERRORLEVEL!
    echo.
    echo Try running as Administrator:
    echo 1. Right-click setup.bat
    echo 2. Select "Run as administrator"
    echo.
)

echo ========================================
echo.
echo Tools:
echo   Check status: status.bat
echo   Test now: test.bat  
echo   Uninstall: uninstall.bat
echo.
echo Location:
echo   %INSTALL_DIR%
echo.
echo Press any key to exit...
pause >nul