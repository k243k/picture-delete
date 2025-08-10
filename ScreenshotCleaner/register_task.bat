@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

echo ========================================
echo ScreenshotCleaner タスク登録
echo ========================================
echo.
echo ⚠️  警告: このツールはスクリーンショットを完全削除します
echo         削除されたファイルは復元できません
echo.

REM スクリプト配置先の準備
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if not exist "%INSTALL_DIR%" (
    echo フォルダを作成中: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

REM clean_screenshots.ps1 が存在しない場合はエラー
if not exist "%INSTALL_DIR%\clean_screenshots.ps1" (
    echo clean_screenshots.ps1 が見つかりません。
    echo インストーラから実行するか、ファイルを配置してください。
    pause
    exit /b 1
)

REM タスク名
set TASK_NAME=ScreenshotCleaner9AM

REM 既存タスクの削除（存在する場合）
echo 既存タスクを確認中...
schtasks /Query /TN "%TASK_NAME%" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo 既存タスクを削除します...
    schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1
)

REM タスクの作成
echo タスクを登録中...
schtasks /Create /SC DAILY /ST 09:00 /TN "%TASK_NAME%" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ タスクの登録が完了しました！
    echo.
    
    REM タスク確認
    echo 登録されたタスク:
    schtasks /Query /TN "%TASK_NAME%" /FO LIST | findstr /C:"タスク名" /C:"TaskName" /C:"次回の実行時刻" /C:"Next Run Time" /C:"状態" /C:"Status"
    
    echo.
    echo ========================================
    echo ⚠️  重要: 初回は必ずドライランでテストしてください
    echo ========================================
    echo.
    echo ドライランコマンド（削除せず確認のみ）:
    echo powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
    echo.
    echo 今すぐドライランを実行しますか？ (Y/N)
    echo （実際の削除は行いません）
    choice /C YN /N /M "選択: "
    if !ERRORLEVEL! EQU 1 (
        echo.
        echo ========================================
        echo ドライランを実行中...
        echo ========================================
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo ========================================
        echo ドライランが完了しました
        echo 上記のファイルが毎朝9:00に完全削除されます
        echo ========================================
        echo.
        echo 実際に削除を実行する場合:
        echo powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1"
    )
) else (
    echo.
    echo × タスクの登録に失敗しました
    echo エラーコード: %ERRORLEVEL%
)

echo.
pause