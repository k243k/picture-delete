@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

echo ========================================
echo GalleryCleaner タスク登録
echo ========================================
echo.

REM スクリプト配置先の準備
set INSTALL_DIR=%LOCALAPPDATA%\GalleryCleaner
if not exist "%INSTALL_DIR%" (
    echo フォルダを作成中: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

REM clean.ps1 が存在しない場合は作成（インストーラ以外での実行用）
if not exist "%INSTALL_DIR%\clean.ps1" (
    echo clean.ps1 が見つかりません。
    echo 同じフォルダに clean.ps1 を配置してから再実行してください。
    pause
    exit /b 1
)

REM タスク名
set TASK_NAME=GalleryCleaner9AM

REM 既存タスクの削除（存在する場合）
echo 既存タスクを確認中...
schtasks /Query /TN "%TASK_NAME%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo 既存タスクを削除します...
    schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1
)

REM タスクの作成
echo タスクを登録中...
schtasks /Create /SC DAILY /ST 09:00 /TN "%TASK_NAME%" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ タスクの登録が完了しました！
    echo.
    
    REM タスク確認
    echo 登録されたタスク:
    schtasks /Query /TN "%TASK_NAME%" /FO LIST | findstr /C:"タスク名" /C:"TaskName" /C:"次回の実行時刻" /C:"Next Run Time" /C:"状態" /C:"Status"
    
    echo.
    echo ========================================
    echo 初回はドライランでテストすることをお勧めします
    echo ========================================
    echo.
    echo テストコマンド（削除せず確認のみ）:
    echo powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean.ps1" -WhatIf
    echo.
    echo 今すぐテスト実行しますか？ (Y/N)
    choice /C YN /N /M "選択: "
    if !ERRORLEVEL! EQU 1 (
        echo.
        echo ドライランを実行中...
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean.ps1" -WhatIf
        echo.
        echo テストが完了しました。
    )
) else (
    echo.
    echo × タスクの登録に失敗しました
    echo エラーコード: %ERRORLEVEL%
)

echo.
pause