========================================
    ScreenshotCleaner - Final Version
========================================

SUPER EASY INSTALLATION
------------------------
Choose ONE file and double-click:

- INSTALL_9AM.bat  = Delete at 9:00 AM
- INSTALL_3PM.bat  = Delete at 3:00 PM

That's it! Just double-click!

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