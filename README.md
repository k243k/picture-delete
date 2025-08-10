# ScreenshotCleaner

スクリーンショットを毎日自動削除 / Automatically delete screenshots daily

[日本語の説明はこちら](README_EASY_JP.md)

## ⚠️ WARNING
- Files are PERMANENTLY deleted (not sent to Recycle Bin)
- Cannot be recovered once deleted

## Quick Start (超簡単！)

### 2ステップで完了
1. `ScreenshotCleaner_Simple` フォルダを開く
2. 【1】と【2】を順番にダブルクリック
3. 完了！

### Simple 2-Step Setup
1. Open `ScreenshotCleaner_Simple` folder
2. Double-click [1] then [2]
3. Done!

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