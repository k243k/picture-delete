@echo off
setlocal
chcp 65001 >nul 2>&1

echo ========================================
echo ScreenshotCleaner アンインストール
echo ========================================
echo.

REM タスクの削除
set TASK_NAME=ScreenshotCleaner9AM
echo タスクを削除中...
schtasks /Delete /TN "%TASK_NAME%" /F >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ タスクを削除しました
) else (
    echo ※ タスクは既に削除されています
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
        echo ✓ すべてのファイルを削除しました
    )
) else (
    echo.
    echo スクリプトのみ削除中...
    if exist "%INSTALL_DIR%\clean_screenshots.ps1" del /Q "%INSTALL_DIR%\clean_screenshots.ps1"
    if exist "%INSTALL_DIR%\register_task.bat" del /Q "%INSTALL_DIR%\register_task.bat"
    if exist "%INSTALL_DIR%\uninstall.bat" del /Q "%INSTALL_DIR%\uninstall.bat"
    if exist "%INSTALL_DIR%\README_jp.md" del /Q "%INSTALL_DIR%\README_jp.md"
    echo ✓ スクリプトを削除しました（ログは保持）
)

echo.
echo ========================================
echo アンインストールが完了しました
echo ========================================
echo.
pause