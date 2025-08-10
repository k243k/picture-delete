@echo off
title Change ScreenshotCleaner Time
cls
echo ========================================
echo   Change ScreenshotCleaner Time
echo ========================================
echo.
echo Current scheduled tasks:
schtasks /Query /TN "ScreenshotCleaner*" 2>nul | findstr "ScreenshotCleaner"
echo.
echo ========================================
echo Select new time:
echo.
echo   1. 3:00 AM  (Early morning)
echo   2. 9:00 AM  (Morning)
echo   3. 12:00 PM (Noon)
echo   4. 3:00 PM  (Afternoon)
echo   5. 6:00 PM  (Evening)
echo   6. 9:00 PM  (Night)
echo   7. Custom time
echo   8. Cancel
echo.
choice /C 12345678 /N /M "Select option (1-8): "

if %ERRORLEVEL% EQU 8 goto :END
if %ERRORLEVEL% EQU 7 goto :CUSTOM
if %ERRORLEVEL% EQU 6 set NEW_TIME=21:00& set TIME_DESC=9:00 PM
if %ERRORLEVEL% EQU 5 set NEW_TIME=18:00& set TIME_DESC=6:00 PM
if %ERRORLEVEL% EQU 4 set NEW_TIME=15:00& set TIME_DESC=3:00 PM
if %ERRORLEVEL% EQU 3 set NEW_TIME=12:00& set TIME_DESC=12:00 PM
if %ERRORLEVEL% EQU 2 set NEW_TIME=09:00& set TIME_DESC=9:00 AM
if %ERRORLEVEL% EQU 1 set NEW_TIME=03:00& set TIME_DESC=3:00 AM

goto :APPLY

:CUSTOM
echo.
set /p NEW_TIME="Enter time (HH:MM format, 24-hour): "
set TIME_DESC=%NEW_TIME%

:APPLY
echo.
echo Changing time to %TIME_DESC%...

:: Try to change all possible task names
schtasks /Change /TN "ScreenshotCleaner9AM" /ST %NEW_TIME% 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Successfully changed ScreenshotCleaner9AM to %TIME_DESC%
)

schtasks /Change /TN "ScreenshotCleaner3AM" /ST %NEW_TIME% 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Successfully changed ScreenshotCleaner3AM to %TIME_DESC%
)

schtasks /Change /TN "ScreenshotCleaner3PM" /ST %NEW_TIME% 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Successfully changed ScreenshotCleaner3PM to %TIME_DESC%
)

echo.
echo ========================================
echo Time change complete!
echo New deletion time: %TIME_DESC%
echo ========================================

:END
echo.
pause