# ScreenshotCleaner - スクリーンショット自動削除
param(
    [switch]$WhatIf
)

# ログ設定
if ($env:LOCALAPPDATA) {
    $logDir = Join-Path $env:LOCALAPPDATA "ScreenshotCleaner\logs"
} else {
    $logDir = Join-Path $env:USERPROFILE "AppData\Local\ScreenshotCleaner\logs"
}
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$logFile = Join-Path $logDir ("{0:yyyy-MM-dd}.log" -f (Get-Date))

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8
    Write-Host $logEntry
}

Write-Log "===== ScreenshotCleaner Start ====="

if ($WhatIf) {
    Write-Log "Test mode - No files will be deleted"
}

# スクリーンショットフォルダ
$dirs = @()
$screenshotsPath = Join-Path ([Environment]::GetFolderPath('MyPictures')) "Screenshots"
if (Test-Path $screenshotsPath) { $dirs += $screenshotsPath }

$capturesPath = Join-Path ([Environment]::GetFolderPath('MyVideos')) "Captures"
if (Test-Path $capturesPath) { $dirs += $capturesPath }

$desktopPath = [Environment]::GetFolderPath('Desktop')
$dirs += $desktopPath

# ファイル収集
$files = @()
foreach ($dir in $dirs) {
    if ($dir -eq $desktopPath) {
        # デスクトップはScreenshotパターンのみ
        $patterns = @("Screenshot*.png", "Screenshot*.jpg")
        foreach ($pattern in $patterns) {
            $found = Get-ChildItem -Path $dir -Filter $pattern -File -Force -ErrorAction SilentlyContinue
            if ($found) { $files += $found }
        }
    } else {
        # その他は全画像
        $exts = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp")
        foreach ($ext in $exts) {
            $found = Get-ChildItem -Path $dir -Filter $ext -Recurse -File -Force -ErrorAction SilentlyContinue
            if ($found) { $files += $found }
        }
    }
}

$totalCount = $files.Count
Write-Log "Found $totalCount files"

if ($totalCount -eq 0) {
    Write-Log "No screenshots found"
    exit 0
}

# 削除処理
$successCount = 0
foreach ($file in $files) {
    try {
        if ($WhatIf) {
            Write-Log "[TEST] Would delete: $($file.FullName)"
            $successCount++
        } else {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            Write-Log "Deleted: $($file.FullName)"
            $successCount++
        }
    } catch {
        Write-Log "Error: $($file.FullName) - $_"
    }
}

Write-Log "Complete: $successCount / $totalCount files"
Write-Log "===== ScreenshotCleaner End ====="