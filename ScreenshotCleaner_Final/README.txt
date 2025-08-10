========================================
    ScreenshotCleaner - Final Version
========================================

SUPER EASY INSTALLATION
------------------------
1. Right-click "install_all.ps1"
2. Select "Run with PowerShell"
3. Press Enter when asked
4. Done!

WHAT IT DOES
------------
- Deletes screenshots at 9:00 AM daily
- From Pictures\Screenshots
- From Videos\Captures
- From Desktop (Screenshot*.png/jpg only)

WARNING
-------
Files are PERMANENTLY deleted!
Cannot be recovered!

TO CHANGE TIME
--------------
Run this in Command Prompt:
schtasks /Change /TN "ScreenshotCleaner9AM" /ST 15:00
(15:00 = 3:00 PM)

TO UNINSTALL
------------
Run these in PowerShell:
schtasks /Delete /TN "ScreenshotCleaner9AM" /F
Remove-Item -Path "$env:LOCALAPPDATA\ScreenshotCleaner" -Recurse -Force

========================================