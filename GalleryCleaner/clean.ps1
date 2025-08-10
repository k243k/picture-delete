# GalleryCleaner - 画像ファイルをゴミ箱へ移動するスクリプト
# 実行例: .\clean.ps1 -WhatIf (ドライラン)
# 実行例: .\clean.ps1 -Targets "C:\Photos","D:\Images"

param(
    [switch]$WhatIf,
    [string[]]$Targets = @()
)

# [1] VisualBasic.dllを読み込み（ゴミ箱送り用）
Add-Type -AssemblyName Microsoft.VisualBasic

# [2] ログフォルダの準備
$logDir = Join-Path $env:LOCALAPPDATA "GalleryCleaner\logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# [3] ログファイル名（日付付き）
$logFile = Join-Path $logDir ("{0:yyyy-MM-dd}.log" -f (Get-Date))

# [4] ログ出力関数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8
    Write-Host $logEntry
}

# [5] 開始ログ
Write-Log "===== GalleryCleaner 開始 ====="
if ($WhatIf) {
    Write-Log "ドライランモード: 実際の削除は行いません" "WARN"
}

# [6] 対象フォルダの設定
$targetDirs = @()
if ($Targets.Count -eq 0) {
    # [7] デフォルト: My Pictures（OneDriveリダイレクトも自動対応）
    $myPictures = [Environment]::GetFolderPath('MyPictures')
    $targetDirs += $myPictures
    Write-Log "対象フォルダ: $myPictures"
} else {
    # [8] 引数で指定されたフォルダ
    foreach ($dir in $Targets) {
        if (Test-Path $dir) {
            $targetDirs += $dir
            Write-Log "対象フォルダ: $dir"
        } else {
            Write-Log "フォルダが存在しません: $dir" "WARN"
        }
    }
}

# [9] 対象拡張子
$extensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.heic", "*.bmp")

# [10] カウンタ初期化
$totalCount = 0
$successCount = 0
$failCount = 0
$startTime = Get-Date

# [11] 対象ファイルの収集
Write-Log "対象ファイルを検索中..."
$allFiles = @()
foreach ($dir in $targetDirs) {
    foreach ($ext in $extensions) {
        # [12] サブフォルダも再帰的に検索、隠しファイルも含む
        $files = Get-ChildItem -Path $dir -Filter $ext -Recurse -File -Force -ErrorAction SilentlyContinue
        if ($files) {
            $allFiles += $files
        }
    }
}

$totalCount = $allFiles.Count
Write-Log "対象ファイル数: $totalCount 件"

if ($totalCount -eq 0) {
    Write-Log "削除対象のファイルが見つかりませんでした"
    Write-Log "===== GalleryCleaner 終了 ====="
    exit 0
}

# [13] ファイルごとにゴミ箱へ移動
foreach ($file in $allFiles) {
    try {
        $filePath = $file.FullName
        
        if ($WhatIf) {
            # [14] ドライラン: 実際には削除しない
            Write-Log "[ドライラン] ゴミ箱へ送る予定: $filePath"
            $successCount++
        } else {
            # [15] ゴミ箱へ送る（完全削除ではない）
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
                $filePath,
                [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs,
                [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin
            )
            Write-Log "ゴミ箱へ送りました: $filePath"
            $successCount++
        }
    } catch {
        # [16] エラー時はログに記録して継続
        $failCount++
        Write-Log "エラー: $filePath - $_" "ERROR"
    }
}

# [17] 処理時間計算
$endTime = Get-Date
$elapsed = $endTime - $startTime
$elapsedStr = "{0:hh\:mm\:ss\.fff}" -f $elapsed

# [18] サマリー出力
Write-Log "===== 処理完了 ====="
Write-Log "対象: $totalCount 件 / 成功: $successCount 件 / 失敗: $failCount 件"
Write-Log "処理時間: $elapsedStr"
Write-Log "===== GalleryCleaner 終了 ====="

# [19] 終了コード（失敗があれば1）
if ($failCount -gt 0 -and -not $WhatIf) {
    exit 1
}
exit 0