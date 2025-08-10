# ScreenshotCleaner

スクリーンショットを毎日自動削除 / Automatically delete screenshots daily

## ⚠️ WARNING
- Files are PERMANENTLY deleted (not sent to Recycle Bin)
- Cannot be recovered once deleted

## Quick Start (1-Click Install!)

### Installation
1. Open `ScreenshotCleaner_Final` folder
2. Right-click `install_all.ps1`
3. Select "Run with PowerShell"
4. Press Enter
5. Done!

### 日本語説明
1. `ScreenshotCleaner_Final` フォルダを開く
2. `install_all.ps1` を右クリック
3. 「PowerShellで実行」を選択
4. Enterキーを押す
5. 完了！

## What Gets Deleted
- `Pictures\Screenshots\` folder (all images)
- `Videos\Captures\` folder (all images)
- Desktop `Screenshot*.png/jpg` files

## Files in ScreenshotCleaner_Easy
- `setup.bat` - Main installer (English, no garbled text)
- `INSTALL.ps1` - PowerShell installer (Works in any language)
- `test.bat` - Test deletion
- `status.bat` - Check status
- `uninstall.bat` - Remove tool
- `clean_screenshots.ps1` - Main script (do not run directly)

## Troubleshooting

### Garbled Text Issue
This version uses English only to avoid encoding problems.

### Installation Failed
Try running as Administrator:
1. Right-click `setup.bat`
2. Select "Run as administrator"

### Check if Working
Run `status.bat` to see if the task is registered.