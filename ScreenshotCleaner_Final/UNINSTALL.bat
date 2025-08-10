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
echo Removing scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Task removed successfully
) else (
    echo Task not found or already removed
)

echo.
echo Removing files...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%" 2>nul
    echo Files removed successfully
) else (
    echo Files not found or already removed
)

echo.
echo ========================================
echo   Uninstall Complete
echo ========================================
echo.
pause