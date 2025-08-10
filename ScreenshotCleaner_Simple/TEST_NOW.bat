@echo off
title Test ScreenshotCleaner
cls
echo ========================================
echo   Test ScreenshotCleaner (Dry Run)
echo ========================================
echo.
echo This will show what files would be deleted
echo (No files will actually be deleted)
echo.
pause

echo.
powershell -ExecutionPolicy Bypass -File "%~dp0clean_screenshots.ps1" -WhatIf
echo.
pause