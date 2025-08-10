========================================
    ScreenshotCleaner - Simple Version
========================================

SUPER SIMPLE INSTALLATION
------------------------
1. Choose ONE file and double-click:

   - INSTALL_9AM.bat  = Delete at 9:00 AM
   - INSTALL_3AM.bat  = Delete at 3:00 AM
   - INSTALL_3PM.bat  = Delete at 3:00 PM

2. When asked "Test now?", press Y to see what will be deleted

That's it!

TEST ANYTIME
------------
Double-click TEST_NOW.bat to see what files would be deleted
(This is safe - no files are actually deleted during test)

WHAT IT DOES
------------
Deletes these screenshots:
- Pictures\Screenshots: ALL images
- Videos\Captures: ALL images
- Desktop: ONLY Screenshot*.png and Screenshot*.jpg

WARNING: Files are PERMANENTLY deleted! Cannot be recovered!

CHECK IF IT'S WORKING
--------------------
Double-click CHECK_STATUS.bat to see:
- If task is installed
- Next run time
- Last run time

CHANGE TIME
-----------
Double-click CHANGE_TIME.bat
OR use command:
schtasks /Change /TN "ScreenshotCleaner9AM" /ST 03:00

Time examples:
- 03:00 = 3:00 AM
- 09:00 = 9:00 AM  
- 15:00 = 3:00 PM
- 21:00 = 9:00 PM

TO UNINSTALL
------------
Double-click UNINSTALL.bat

========================================