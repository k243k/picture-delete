@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   ScreenshotCleaner Uninstall
echo ========================================
echo.

echo Removing scheduled task...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    echo     OK: Task removed
) else (
    echo     Task not found
)

echo.
echo Removing files...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%"
    echo     OK: Files removed
) else (
    echo     Files not found
)

echo.
echo Uninstall complete
echo.
pause