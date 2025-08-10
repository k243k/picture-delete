@echo off
setlocal enabledelayedexpansion
title ScreenshotCleaner Status

echo ========================================
echo   ScreenshotCleaner Status
echo ========================================
echo.

REM Check task
echo [1] Checking scheduled task...
schtasks /Query /TN "ScreenshotCleaner9AM" >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo     OK: Task is registered
    echo.
    echo     Details:
    for /f "tokens=1,2,*" %%a in ('schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST ^| findstr /C:"Next Run Time:"') do (
        echo     %%a %%b %%c
    )
    for /f "tokens=1,2,*" %%a in ('schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST ^| findstr /C:"Status:"') do (
        echo     %%a %%b %%c
    )
) else (
    echo     NOT FOUND: Please run setup.bat
)

echo.
echo [2] Checking files...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%\clean_screenshots.ps1" (
    echo     OK: Script file exists
    echo     Location: %INSTALL_DIR%
) else (
    echo     NOT FOUND: Please run setup.bat
)

echo.
echo [3] Checking logs...
if exist "%INSTALL_DIR%\logs" (
    echo     OK: Log folder exists
    dir "%INSTALL_DIR%\logs\*.log" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo     Recent logs:
        for /f "delims=" %%i in ('dir /b /o-d "%INSTALL_DIR%\logs\*.log" 2^>nul') do (
            echo       - %%i
            goto :logend
        )
        :logend
    ) else (
        echo     No logs yet (not run yet)
    )
) else (
    echo     No logs yet (not run yet)
)

echo.
echo ========================================
echo.
echo Press any key to exit...
pause >nul