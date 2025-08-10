@echo off
title Uninstall ScreenshotCleaner
cls
echo ========================================
echo   Uninstall ScreenshotCleaner
echo ========================================
echo.
echo This will remove the automatic deletion.
echo.
pause

echo.
echo Removing scheduled tasks...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
schtasks /Delete /TN "ScreenshotCleaner3AM" /F >nul 2>&1
schtasks /Delete /TN "ScreenshotCleaner3PM" /F >nul 2>&1
echo Tasks removed

echo.
echo Removing files...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%" 2>nul
    echo Files removed
) else (
    echo No files found
)

echo.
echo ========================================
echo   Uninstall Complete
echo ========================================
echo.
pause