@echo off
chcp 932 >nul 2>&1

echo ========================================
echo   ScreenshotCleaner テスト
echo ========================================
echo.

set SCRIPT=%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1

if not exist "%SCRIPT%" (
    echo エラー: セットアップが完了していません
    echo setup.bat を先に実行してください
    pause
    exit /b 1
)

echo 1. テスト（削除しない）
echo 2. 実行（削除する）
echo 3. 終了
echo.
choice /C 123 /N /M "選択 (1-3): "

if %ERRORLEVEL% EQU 1 (
    echo.
    echo テスト実行中...
    powershell -ExecutionPolicy Bypass -File "%SCRIPT%" -WhatIf
    echo.
    pause
)

if %ERRORLEVEL% EQU 2 (
    echo.
    echo 本当に削除しますか？ (Y/N)
    choice /C YN /N
    if %ERRORLEVEL% EQU 1 (
        echo.
        echo 削除中...
        powershell -ExecutionPolicy Bypass -File "%SCRIPT%"
        echo.
        pause
    )
)