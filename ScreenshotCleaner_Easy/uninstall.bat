@echo off
chcp 932 >nul 2>&1

echo ========================================
echo   ScreenshotCleaner アンインストール
echo ========================================
echo.

echo タスクを削除中...
schtasks /Delete /TN "ScreenshotCleaner9AM" /F >nul 2>&1

echo ファイルを削除中...
set INSTALL_DIR=%LOCALAPPDATA%\ScreenshotCleaner
if exist "%INSTALL_DIR%" (
    rmdir /S /Q "%INSTALL_DIR%"
)

echo.
echo アンインストール完了
echo.
pause