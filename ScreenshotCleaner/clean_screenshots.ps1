# ScreenshotCleaner - スクリーンショットを完全削除するスクリプト
# 警告: このスクリプトは対象ファイルを完全削除します（復元不可）
# 実行例: .\clean_screenshots.ps1 -WhatIf (ドライラン)
# 実行例: .\clean_screenshots.ps1 -AdditionalPaths "C:\Temp","D:\Downloads"

param(
    [switch]$WhatIf,
    [string[]]$AdditionalPaths = @()
)

# [1] ログフォルダの準備
$logDir = Join-Path $env:LOCALAPPDATA "ScreenshotCleaner\logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# [2] ログファイル名（日付付き）
$logFile = Join-Path $logDir ("{0:yyyy-MM-dd}.log" -f (Get-Date))

# [3] ログ出力関数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8
    Write-Host $logEntry
}

# [4] 開始ログ
Write-Log "===== ScreenshotCleaner 開始 ====="
if ($WhatIf) {
    Write-Log "ドライランモード: 実際の削除は行いません" "WARN"
} else {
    Write-Log "警告: 完全削除モード - ファイルは復元できません" "WARN"
}

# [5] スクリーンショットの標準保存場所
$screenshotDirs = @()

# Windows標準のScreenshotsフォルダ
$picturesPath = [Environment]::GetFolderPath('MyPictures')
$screenshotsPath = Join-Path $picturesPath "Screenshots"
if (Test-Path $screenshotsPath) {
    $screenshotDirs += $screenshotsPath
    Write-Log "対象フォルダ: $screenshotsPath"
}

# ゲームバーのキャプチャフォルダ
$videosPath = [Environment]::GetFolderPath('MyVideos')
$capturesPath = Join-Path $videosPath "Captures"
if (Test-Path $capturesPath) {
    $screenshotDirs += $capturesPath
    Write-Log "対象フォルダ: $capturesPath"
}

# デスクトップ（スクリーンショットがよく保存される場所）
$desktopPath = [Environment]::GetFolderPath('Desktop')
$screenshotDirs += $desktopPath
Write-Log "対象フォルダ: $desktopPath (スクリーンショットファイルのみ)"

# [6] 追加パスがあれば含める
foreach ($path in $AdditionalPaths) {
    if (Test-Path $path) {
        $screenshotDirs += $path
        Write-Log "追加対象フォルダ: $path"
    } else {
        Write-Log "フォルダが存在しません: $path" "WARN"
    }
}

# [7] スクリーンショットのファイル名パターン
$screenshotPatterns = @(
    "Screenshot*.png",
    "Screenshot*.jpg",
    "スクリーンショット*.png",
    "スクリーンショット*.jpg",
    "Capture*.png",
    "Capture*.jpg",
    "画面*.png",
    "画面*.jpg",
    "Screen*.png",
    "Screen*.jpg"
)

# [8] カウンタ初期化
$totalCount = 0
$successCount = 0
$failCount = 0
$startTime = Get-Date

# [9] 対象ファイルの収集
Write-Log "スクリーンショットファイルを検索中..."
$allFiles = @()

foreach ($dir in $screenshotDirs) {
    if ($dir -eq $desktopPath) {
        # [10] デスクトップは特定のパターンのみ検索（サブフォルダなし）
        foreach ($pattern in $screenshotPatterns) {
            $files = Get-ChildItem -Path $dir -Filter $pattern -File -Force -ErrorAction SilentlyContinue
            if ($files) {
                $allFiles += $files
            }
        }
    } else {
        # [11] その他のフォルダは全画像ファイルを対象（スクリーンショット専用フォルダ）
        $extensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp")
        foreach ($ext in $extensions) {
            $files = Get-ChildItem -Path $dir -Filter $ext -Recurse -File -Force -ErrorAction SilentlyContinue
            if ($files) {
                $allFiles += $files
            }
        }
    }
}

# [12] 重複を除外
$allFiles = $allFiles | Sort-Object -Property FullName -Unique

$totalCount = $allFiles.Count
Write-Log "対象ファイル数: $totalCount 件"

if ($totalCount -eq 0) {
    Write-Log "削除対象のスクリーンショットが見つかりませんでした"
    Write-Log "===== ScreenshotCleaner 終了 ====="
    exit 0
}

# [13] 削除前の最終確認（ドライランでない場合）
if (-not $WhatIf -and $totalCount -gt 50) {
    Write-Log "大量のファイル（$totalCount 件）が削除対象です" "WARN"
}

# [14] ファイルごとに完全削除
foreach ($file in $allFiles) {
    try {
        $filePath = $file.FullName
        $fileSize = [math]::Round($file.Length / 1KB, 2)
        $fileDate = $file.CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
        
        if ($WhatIf) {
            # [15] ドライラン: 実際には削除しない
            Write-Log "[ドライラン] 削除予定: $filePath (${fileSize}KB, 作成日: $fileDate)"
            $successCount++
        } else {
            # [16] 完全削除（ゴミ箱を経由しない）
            Remove-Item -Path $filePath -Force -ErrorAction Stop
            Write-Log "完全削除しました: $filePath (${fileSize}KB)"
            $successCount++
        }
    } catch {
        # [17] エラー時はログに記録して継続
        $failCount++
        Write-Log "削除エラー: $filePath - $_" "ERROR"
    }
}

# [18] 処理時間計算
$endTime = Get-Date
$elapsed = $endTime - $startTime
$elapsedStr = "{0:hh\:mm\:ss\.fff}" -f $elapsed

# [19] 削除容量の計算（概算）
$totalSizeKB = ($allFiles | Where-Object { $_ -ne $null } | Measure-Object -Property Length -Sum).Sum / 1KB
$totalSizeMB = [math]::Round($totalSizeKB / 1024, 2)

# [20] サマリー出力
Write-Log "===== 処理完了 ====="
Write-Log "対象: $totalCount 件 / 成功: $successCount 件 / 失敗: $failCount 件"
Write-Log "削除容量: 約 $totalSizeMB MB"
Write-Log "処理時間: $elapsedStr"
Write-Log "===== ScreenshotCleaner 終了 ====="

# [21] 終了コード（失敗があれば1）
if ($failCount -gt 0 -and -not $WhatIf) {
    exit 1
}
exit 0