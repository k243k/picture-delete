# ScreenshotCleaner - スクリーンショット自動削除ツール

毎朝9:00にスクリーンショットを**完全削除**するツールです。

## ⚠️ 重要な警告
- **完全削除** - ゴミ箱を経由せず、ファイルは永久に削除されます
- **復元不可能** - 削除されたファイルは取り戻せません
- **自動実行** - 毎朝9:00に自動で削除が実行されます

## 特徴
- ✅ **管理者権限不要** - 通常ユーザーでインストール可能
- ✅ **スクリーンショット専用** - スクリーンショットのみを対象
- ✅ **簡単インストール** - 次へボタンを押すだけ
- ✅ **詳細ログ** - 削除したファイルの記録を保存

## 削除対象

### 対象フォルダ
- `%USERPROFILE%\Pictures\Screenshots\` - Windows標準
- `%USERPROFILE%\Videos\Captures\` - ゲームバー
- `%USERPROFILE%\Desktop\` - デスクトップ（スクリーンショットファイルのみ）

### 対象ファイル名
- `Screenshot*.png/jpg` - Windows標準
- `スクリーンショット*.png/jpg` - 日本語Windows
- `Capture*.png/jpg` - ゲームバー
- `Screen*.png/jpg` - その他ツール

## インストール手順

### (1) ダウンロード
`ScreenshotCleanerSetup.exe` をダウンロードします。

### (2) セットアップ起動
ダウンロードした `ScreenshotCleanerSetup.exe` をダブルクリックします。
「WindowsによってPCが保護されました」と表示された場合：
1. 「詳細情報」をクリック
2. 「実行」をクリック

### (3) 警告確認
⚠️ **完全削除の警告**が表示されます。内容を確認して「はい」をクリック。

### (4) インストール画面
1. 言語選択: 「日本語」を選択 → 「OK」
2. セットアップウィザード: 「次へ」をクリック
3. インストール先: そのまま「次へ」をクリック
4. インストール準備: 「インストール」をクリック

### (5) インストール完了
1. 「今すぐドライランでテスト」のチェックを**必ず**入れる
2. 「完了」をクリック

### (6) 動作確認（重要）
ドライランで削除対象を確認してください。
表示されたファイルが毎朝削除されます。

## 使い方

### 自動実行
インストール後は何もする必要はありません。
毎朝9:00に自動でスクリーンショットが完全削除されます。

### 手動実行

#### ドライラン（必ず最初に実行）
```powershell
# 削除せず対象ファイルを確認
powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" -WhatIf
```

#### 実際に削除（注意！）
```powershell
# ⚠️ 完全削除を実行
powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1"
```

### 追加フォルダの指定
```powershell
# 他のフォルダも対象に含める
powershell -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\ScreenshotCleaner\clean_screenshots.ps1" -AdditionalPaths "C:\Temp","D:\Downloads"
```

### ログ確認
削除結果は以下の場所に記録されます：
```
%LOCALAPPDATA%\ScreenshotCleaner\logs\YYYY-MM-DD.log
```

## アンインストール

### 方法1: コントロールパネル
1. 「設定」→「アプリ」→「アプリと機能」
2. 「ScreenshotCleaner」を検索
3. 「アンインストール」をクリック

### 方法2: 手動削除
```bat
%LOCALAPPDATA%\ScreenshotCleaner\uninstall.bat
```

## トラブルシューティング

### 実行ポリシーエラーが出る場合
1. PowerShellスクリプト（clean_screenshots.ps1）を右クリック
2. 「プロパティ」を選択
3. 「全般」タブの下部「セキュリティ」欄
4. 「ブロックの解除」にチェック → 「OK」

### 企業のウイルス対策ソフトでブロックされる場合
IT管理者に以下のフォルダを例外登録してもらってください：
```
%LOCALAPPDATA%\ScreenshotCleaner
```

### タスクが実行されない場合
以下を確認してください：
- **PCがスリープ中**: スリープ解除時刻を8:50頃に設定
- **ユーザー未ログオン**: ログオン状態で9:00を迎える必要があります
- **時刻がずれている**: Windowsの時刻設定を確認
- **タスクが無効化**: タスクスケジューラで「ScreenshotCleaner9AM」を確認

### タスクの状態確認
```bat
schtasks /Query /TN "ScreenshotCleaner9AM"
```

### 重要なスクリーンショットがある場合
削除前に以下の対策を行ってください：
1. 重要なスクリーンショットを別フォルダに移動
2. クラウドストレージにバックアップ
3. ファイル名を変更（Screenshot以外の名前に）

### サポートに連絡する場合
以下の情報を提供してください：
1. ログファイル: `%LOCALAPPDATA%\ScreenshotCleaner\logs\`
2. Windowsバージョン: `winver` コマンドで確認
3. エラーメッセージのスクリーンショット

## 注意事項

### ⚠️ データ損失のリスク
- **完全削除のため復元不可能**
- 削除前に重要なファイルのバックアップを推奨
- 初回は必ずドライランで対象を確認

### 削除されるファイル
- Screenshotsフォルダ内の**すべての画像**
- デスクトップの**Screenshot*パターンのファイル**
- ゲームバーのキャプチャフォルダ内の画像

### 削除されないファイル
- Screenshotパターン以外のデスクトップファイル
- ピクチャフォルダ直下の画像（Screenshotsフォルダ以外）
- 他のフォルダの画像ファイル

## よくある質問

### Q: ゴミ箱に送ることはできますか？
A: このツールは容量節約のため完全削除専用です。ゴミ箱版が必要な場合は別途お問い合わせください。

### Q: 特定のファイルを除外できますか？
A: 現バージョンでは除外機能はありません。重要なファイルは事前に移動してください。

### Q: 削除時刻を変更できますか？
A: タスクスケジューラで「ScreenshotCleaner9AM」を編集して変更可能です。

## ライセンス
このツールはフリーソフトウェアです。
使用は自己責任でお願いします。