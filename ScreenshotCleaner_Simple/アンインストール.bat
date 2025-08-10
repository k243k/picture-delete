@echo off
title Uninstall ScreenshotCleaner
cls

echo =======================================
echo   Uninstall ScreenshotCleaner
echo =======================================
echo.
echo This will:
echo   - Stop automatic deletion
echo   - Remove all files
echo.
echo Continue? (Y/N)
choice /C YN /N /M "Select: "

if %ERRORLEVEL% EQU 2 exit

echo.
echo Removing scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo OK - Task removed
) else (
    echo Task not found (already removed)
)

echo.
echo Removing files...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%" 2>nul
    echo OK - Files removed
) else (
    echo Files not found (already removed)
)

echo.
echo =======================================
echo   Uninstall complete!
echo =======================================
echo.
pause