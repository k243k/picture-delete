# 文字化けを修正するスクリプト
# このスクリプトをPowerShellで実行すると、バッチファイルがShift-JISで再作成されます

Write-Host "ScreenshotCleaner の文字化けを修正します..." -ForegroundColor Green

# インストール先
$installDir = "$env:LOCALAPPDATA\ScreenshotCleaner"

# フォルダが存在しない場合は作成
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    Write-Host "フォルダを作成しました: $installDir" -ForegroundColor Yellow
}

# register_task.bat を Shift-JIS で作成
Write-Host "register_task.bat を修正中..." -ForegroundColor Cyan

$registerContent = @'
@echo off
setlocal enabledelayedexpansion
chcp 932 >nul 2>&1

echo ========================================
echo ScreenshotCleaner タスク登録
echo ========================================
echo.
echo 警告: このツールはスクリーンショットを完全削除します
echo       削除されたファイルは復元できません
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
    echo ファイルを配置してから再実行してください。
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
    echo タスクの登録が完了しました！
    echo.
    
    REM タスク確認
    echo 登録されたタスク:
    schtasks /Query /TN "%TASK_NAME%" /FO LIST | findstr /C:"タスク名" /C:"TaskName" /C:"次回の実行時刻" /C:"Next Run Time" /C:"状態" /C:"Status"
    
    echo.
    echo ========================================
    echo 重要: 初回は必ずドライランでテストしてください
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
    )
) else (
    echo.
    echo タスクの登録に失敗しました
    echo エラーコード: %ERRORLEVEL%
)

echo.
pause
'@

# Shift-JIS (CP932) で保存
$encoding = [System.Text.Encoding]::GetEncoding(932)
[System.IO.File]::WriteAllText("$installDir\register_task.bat", $registerContent, $encoding)
Write-Host "✓ register_task.bat を修正しました" -ForegroundColor Green

# uninstall.bat も修正
Write-Host "uninstall.bat を修正中..." -ForegroundColor Cyan

$uninstallContent = @'
@echo off
setlocal
chcp 932 >nul 2>&1

echo ========================================
echo ScreenshotCleaner アンインストール
echo ========================================
echo.

REM タスクの削除
set TASK_NAME=ScreenshotCleaner9AM
echo タスクを削除中...
schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo タスクを削除しました
) else (
    echo タスクは既に削除されています
)

REM ファイルとフォルダの削除
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
echo.
echo ログファイルも含めて完全に削除しますか？
echo （ログを残したい場合は N を選択してください）
choice /C YN /N /M "選択 (Y/N): "

if %ERRORLEVEL% EQU 1 (
    echo.
    echo フォルダを削除中...
    if exist "%INSTALL_DIR%" (
        rmdir /S /Q "%INSTALL_DIR%"
        echo すべてのファイルを削除しました
    )
) else (
    echo.
    echo スクリプトのみ削除中...
    if exist "%INSTALL_DIR%\clean_screenshots.ps1" del /Q "%INSTALL_DIR%\clean_screenshots.ps1"
    if exist "%INSTALL_DIR%\register_task.bat" del /Q "%INSTALL_DIR%\register_task.bat"
    if exist "%INSTALL_DIR%\uninstall.bat" del /Q "%INSTALL_DIR%\uninstall.bat"
    echo スクリプトを削除しました（ログは保持）
)

echo.
echo ========================================
echo アンインストールが完了しました
echo ========================================
echo.
pause
'@

[System.IO.File]::WriteAllText("$installDir\uninstall.bat", $uninstallContent, $encoding)
Write-Host "✓ uninstall.bat を修正しました" -ForegroundColor Green

# test_now.bat も修正
Write-Host "test_now.bat を修正中..." -ForegroundColor Cyan

$testContent = @'
@echo off
setlocal enabledelayedexpansion
chcp 932 >nul 2>&1

echo ========================================
echo ScreenshotCleaner テスト実行
echo ========================================
echo.

set SCRIPT_PATH=%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1

if not exist "%SCRIPT_PATH%" (
    echo スクリプトが見つかりません
    set SCRIPT_PATH=clean_screenshots.ps1
)

echo 1. ドライラン（削除せず確認のみ）
echo 2. 実際に削除を実行（警告: 復元不可）
echo 3. 終了
echo.
choice /C 123 /N /M "選択 (1-3): "

if %ERRORLEVEL% EQU 1 (
    echo.
    echo ドライランを実行中...
    powershell -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" -WhatIf
    pause
)

if %ERRORLEVEL% EQU 2 (
    echo.
    echo 本当に削除しますか？ (Y/N)
    choice /C YN /N /M "選択: "
    if !ERRORLEVEL! EQU 1 (
        powershell -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
    )
    pause
)
'@

[System.IO.File]::WriteAllText("$installDir\test_now.bat", $testContent, $encoding)
Write-Host "✓ test_now.bat を修正しました" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "修正が完了しました！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "`n以下のファイルがShift-JISで再作成されました:" -ForegroundColor Cyan
Write-Host "  - $installDir\register_task.bat"
Write-Host "  - $installDir\uninstall.bat"
Write-Host "  - $installDir\test_now.bat"
Write-Host "`nregister_task.bat をダブルクリックして再度実行してください。" -ForegroundColor Yellow
Write-Host "今度は日本語が正しく表示されるはずです。" -ForegroundColor Green