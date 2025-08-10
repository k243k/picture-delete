@echo off
setlocal enabledelayedexpansion
chcp 932 >nul 2>&1
title ScreenshotCleaner セットアップ
color 0E

cls
echo ========================================
echo   ScreenshotCleaner かんたんセットアップ
echo ========================================
echo.
echo このプログラムは毎朝9時にスクリーンショットを
echo 自動削除します。
echo.
echo ※削除したファイルは復元できません！
echo.
echo セットアップを開始するには何かキーを押してください...
pause >nul

cls
echo ========================================
echo   セットアップ中...
echo ========================================
echo.

REM 現在のフォルダを取得
set CURRENT_DIR=%~dp0
set CURRENT_DIR=%CURRENT_DIR:~0,-1%

REM インストール先フォルダ
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner

REM ステップ1: フォルダ作成
echo [1/4] フォルダを準備中...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo     × フォルダ作成失敗
        echo     エラーコード: !ERRORLEVEL!
        pause
        exit /b 1
    )
)
echo     ○ 完了

REM ステップ2: ファイルコピー
echo [2/4] ファイルをコピー中...
set COPY_ERROR=0

copy /Y "%CURRENT_DIR%\clean_screenshots.ps1" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\test_now.bat" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\uninstall.bat" "%INSTALL_DIR%\" >nul 2>&1
if !ERRORLEVEL! NEQ 0 set COPY_ERROR=1

copy /Y "%CURRENT_DIR%\check_status.bat" "%INSTALL_DIR%\" >nul 2>&1

if !COPY_ERROR! EQU 0 (
    echo     ○ 完了
) else (
    echo     × ファイルコピー失敗
    echo     現在のフォルダ: %CURRENT_DIR%
    pause
    exit /b 1
)

REM ステップ3: 既存タスク削除
echo [3/4] 既存の設定をクリア中...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
echo     ○ 完了

REM ステップ4: タスク登録
echo [4/4] 自動実行を設定中...
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F >nul 2>&1

if !ERRORLEVEL! EQU 0 (
    echo     ○ 完了
    echo.
    color 0A
    echo ========================================
    echo   セットアップ完了！
    echo ========================================
    echo.
    echo 設定内容:
    echo   実行時刻: 毎朝 9:00
    echo   インストール先: %INSTALL_DIR%
    echo.
    schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST | findstr /C:"次回の実行時刻" /C:"Next Run Time"
    echo.
    echo ----------------------------------------
    echo.
    echo 今すぐテストしますか？
    echo （どのファイルが削除されるか確認できます）
    echo.
    echo   Y = テストする（推奨）
    echo   N = 終了
    echo.
    choice /C YN /N /M "選択してください (Y/N): "
    
    if !ERRORLEVEL! EQU 1 (
        cls
        echo ========================================
        echo   テスト実行中（削除しません）
        echo ========================================
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo ========================================
        echo   テスト完了
        echo ========================================
        echo.
        echo 上記のファイルが毎朝9時に削除されます。
        echo.
    )
) else (
    color 0C
    echo     × 失敗
    echo.
    echo ========================================
    echo   エラー
    echo ========================================
    echo.
    echo タスクの登録に失敗しました。
    echo エラーコード: !ERRORLEVEL!
    echo.
    echo 管理者として実行してみてください：
    echo 1. setup.bat を右クリック
    echo 2. 「管理者として実行」を選択
    echo.
)

echo ========================================
echo.
echo 便利な機能:
echo   状態確認: check_status.bat
echo   手動テスト: test_now.bat  
echo   アンインストール: uninstall.bat
echo.
echo インストール先:
echo   %INSTALL_DIR%
echo.
echo 終了するには何かキーを押してください...
pause >nul