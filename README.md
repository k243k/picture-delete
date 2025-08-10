# ScreenshotCleaner

Automatically delete screenshots at 9:00 AM daily.

## ⚠️ WARNING
- Files are PERMANENTLY deleted (not sent to Recycle Bin)
- Cannot be recovered once deleted

## Quick Start

### Option 1: Batch File (Recommended)
1. Download ZIP from GitHub
2. Extract `ScreenshotCleaner_Easy` folder
3. Double-click `setup.bat`
4. Press Y to test
5. Done!

### Option 2: PowerShell
1. Download ZIP from GitHub
2. Extract `ScreenshotCleaner_Easy` folder
3. Right-click `INSTALL.ps1`
4. Select "Run with PowerShell"
5. Done!

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