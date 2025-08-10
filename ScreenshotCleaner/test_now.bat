@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

echo ========================================
echo ScreenshotCleaner テスト実行
echo ========================================
echo.
echo このツールでScreenshotCleanerをテストできます
echo.

set SCRIPT_PATH=%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1

REM スクリプトの存在確認
if not exist "%SCRIPT_PATH%" (
    echo ⚠️ スクリプトが見つかりません
    echo 期待される場所: %SCRIPT_PATH%
    echo.
    echo 現在のフォルダから実行を試みます...
    set SCRIPT_PATH=clean_screenshots.ps1
    if not exist "!SCRIPT_PATH!" (
        echo エラー: clean_screenshots.ps1 が見つかりません
        pause
        exit /b 1
    )
)

:MENU
echo ========================================
echo テストメニュー
echo ========================================
echo 1. ドライラン（削除せず確認のみ）※推奨
echo 2. 実際に削除を実行 ⚠️警告: 復元不可
echo 3. タスクから即実行
echo 4. 現在の時刻を5分後に変更（テスト用）
echo 5. 終了
echo.
choice /C 12345 /N /M "選択してください (1-5): "

if %ERRORLEVEL% EQU 1 goto DRYRUN
if %ERRORLEVEL% EQU 2 goto REALRUN
if %ERRORLEVEL% EQU 3 goto TASKRUN
if %ERRORLEVEL% EQU 4 goto CHANGETIME
if %ERRORLEVEL% EQU 5 goto END

:DRYRUN
echo.
echo ========================================
echo ドライランを実行中...
echo ========================================
powershell -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" -WhatIf
echo.
echo ========================================
echo ドライラン完了
echo 上記のファイルが削除対象です
echo ========================================
echo.
pause
goto MENU

:REALRUN
echo.
echo ========================================
echo ⚠️  最終確認
echo ========================================
echo 本当にスクリーンショットを完全削除しますか？
echo 削除されたファイルは復元できません！
echo.
choice /C YN /N /M "実行しますか？ (Y/N): "
if %ERRORLEVEL% EQU 2 goto MENU

echo.
echo ========================================
echo 完全削除を実行中...
echo ========================================
powershell -ExecutionPolicy Bypass -File "%SCRIPT_PATH%"
echo.
echo ========================================
echo 削除完了
echo ========================================
echo.
pause
goto MENU

:TASKRUN
echo.
echo ========================================
echo タスクから実行中...
echo ========================================
schtasks /Run /TN "ScreenshotCleaner9AM"
if %ERRORLEVEL% EQU 0 (
    echo ✓ タスクを開始しました
    echo バックグラウンドで実行されています
) else (
    echo × タスクの実行に失敗しました
    echo タスクが登録されていない可能性があります
)
echo.
pause
goto MENU

:CHANGETIME
echo.
echo ========================================
echo テスト用時刻変更
echo ========================================
echo.

REM 現在時刻を取得
for /f "tokens=1-2 delims=:" %%a in ('echo %time:~0,5%') do (
    set hour=%%a
    set min=%%b
)

REM 5分後を計算
set /a min+=5
if !min! GEQ 60 (
    set /a min-=60
    set /a hour+=1
    if !hour! GEQ 24 set hour=0
)

REM ゼロパディング
if !hour! LSS 10 set hour=0!hour!
if !min! LSS 10 set min=0!min!

set NEWTIME=!hour!:!min!

echo 現在時刻: %time:~0,5%
echo 新しい実行時刻: !NEWTIME!
echo.
echo この時刻でタスクを再登録しますか？
choice /C YN /N /M "選択 (Y/N): "

if %ERRORLEVEL% EQU 1 (
    echo.
    echo タスクを再登録中...
    schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1
    schtasks /Create /SC DAILY /ST !NEWTIME! /TN "ScreenshotCleaner9AM" /TR "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1\"" /F
    
    if !ERRORLEVEL! EQU 0 (
        echo.
        echo ✓ タスクを !NEWTIME! に設定しました
        echo.
        schtasks /Query /TN "ScreenshotCleaner9AM" /FO LIST | findstr /C:"次回の実行時刻" /C:"Next Run Time"
    ) else (
        echo × タスクの登録に失敗しました
    )
)
echo.
pause
goto MENU

:END
echo.
echo 終了します
exit /b 0