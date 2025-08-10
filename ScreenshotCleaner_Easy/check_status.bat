@echo off
chcp 932 >nul 2>&1
title ScreenshotCleaner 状態確認

echo ========================================
echo   ScreenshotCleaner 状態確認
echo ========================================
echo.

REM タスクの確認
echo [1] タスクスケジューラの確認...
schtasks /Query /TN "ScreenshotCleaner9AM" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo     ○ タスクは登録されています
    echo.
    echo     詳細情報:
    schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST | findstr /C:"次回の実行時刻" /C:"Next Run Time" /C:"状態" /C:"Status"
) else (
    echo     × タスクが登録されていません
    echo     setup.bat を実行してください
)

echo.
echo [2] ファイルの確認...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%\clean_screenshots.ps1" (
    echo     ○ スクリプトファイルあり
    echo     場所: %INSTALL_DIR%
) else (
    echo     × スクリプトファイルなし
    echo     setup.bat を実行してください
)

echo.
echo [3] ログファイルの確認...
if exist "%INSTALL_DIR%\logs" (
    echo     ○ ログフォルダあり
    dir "%INSTALL_DIR%\logs\*.log" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo     最近のログ:
        for /f "delims=" %%i in ('dir /b /o-d "%INSTALL_DIR%\logs\*.log" 2^>nul') do (
            echo       - %%i
            goto :logend
        )
        :logend
    ) else (
        echo     まだ実行されていません
    )
) else (
    echo     まだ実行されていません
)

echo.
echo ========================================
echo.
echo 操作:
echo 1. 今すぐテスト実行（削除しない）
echo 2. 今すぐ本番実行（削除する）
echo 3. タスクを無効化
echo 4. タスクを有効化
echo 5. 終了
echo.
choice /C 12345 /N /M "選択 (1-5): "

if %ERRORLEVEL% EQU 1 (
    echo.
    echo テスト実行中...
    powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
    pause
    goto :end
)

if %ERRORLEVEL% EQU 2 (
    echo.
    echo 本番実行中...
    powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1"
    pause
    goto :end
)

if %ERRORLEVEL% EQU 3 (
    echo.
    schtasks /Change /TN "ScreenshotCleaner9AM" /DISABLE
    echo タスクを無効化しました
    pause
    goto :end
)

if %ERRORLEVEL% EQU 4 (
    echo.
    schtasks /Change /TN "ScreenshotCleaner9AM" /ENABLE
    echo タスクを有効化しました
    pause
    goto :end
)

:end