@echo off
chcp 932 >nul 2>&1
title ScreenshotCleaner セットアップ

echo ========================================
echo   ScreenshotCleaner かんたんセットアップ
echo ========================================
echo.
echo このプログラムは毎朝9時にスクリーンショットを
echo 自動削除します。
echo.
echo ※削除したファイルは復元できません
echo.
pause

echo.
echo セットアップを開始します...
echo.

REM 現在のフォルダを取得
set CURRENT_DIR=%~dp0
set CURRENT_DIR=%CURRENT_DIR:~0,-1%

REM インストール先フォルダ
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner

REM フォルダ作成
echo ステップ 1/3: フォルダを準備中...
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" >nul 2>&1
)

REM ファイルコピー
echo ステップ 2/3: ファイルをコピー中...
copy /Y "%CURRENT_DIR%\clean_screenshots.ps1" "%INSTALL_DIR%\" >nul 2>&1
copy /Y "%CURRENT_DIR%\test_now.bat" "%INSTALL_DIR%\" >nul 2>&1
copy /Y "%CURRENT_DIR%\uninstall.bat" "%INSTALL_DIR%\" >nul 2>&1

REM タスク登録
echo ステップ 3/3: 自動実行を設定中...
schtasks /Create /SC DAILY /ST 09:00 /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%INSTALL_DIR%\clean_screenshots.ps1\"" /F >nul 2>&1

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo    セットアップ完了！
    echo ========================================
    echo.
    echo 明日の朝9時から自動でスクリーンショットが
    echo 削除されます。
    echo.
    echo 今すぐテストしますか？
    echo （どのファイルが削除されるか確認できます）
    echo.
    echo Y = テストする
    echo N = 終了
    echo.
    choice /C YN /N /M "選択してください (Y/N): "
    
    if !ERRORLEVEL! EQU 1 (
        echo.
        echo ========================================
        echo テスト実行中（実際には削除しません）
        echo ========================================
        echo.
        powershell -ExecutionPolicy Bypass -File "%INSTALL_DIR%\clean_screenshots.ps1" -WhatIf
        echo.
        echo ========================================
        echo 上記のファイルが毎朝削除されます
        echo ========================================
    )
) else (
    echo.
    echo エラー: セットアップに失敗しました
    echo もう一度実行してください
)

echo.
echo アンインストール方法:
echo %INSTALL_DIR%\uninstall.bat
echo を実行してください
echo.
pause