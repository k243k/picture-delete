# ScreenshotCleaner - スクリーンショット自動削除ツール

毎朝指定時刻にスクリーンショットを自動削除するツールです。

## ⚠️ 重要な警告
**削除されたファイルは二度と復元できません！**

## 🚀 かんたん3ステップ設定

### ステップ1: ダウンロード
1. 緑の「Code」ボタンをクリック
2. 「Download ZIP」をクリック
3. ZIPファイルを解凍

### ステップ2: 修正プログラムを実行（重要！）
1. `ScreenshotCleaner_Easy` フォルダを開く
2. **`FIX_NOW.bat`** をダブルクリック
3. 画面にファイル一覧が表示されたら成功

### ステップ3: インストール
1. **`setup.bat`** をダブルクリック
2. 「Y」を押してEnter（テスト実行）
3. 完了！

## 📁 削除される場所
- `ピクチャ\Screenshots` フォルダ内の全画像
- `ビデオ\Captures` フォルダ内の全画像
- デスクトップの `Screenshot*.png/jpg` ファイル

## ⏰ 実行時刻の変更方法
初期設定は朝9時です。変更したい場合：

### 午後3時に変更する例
```cmd
schtasks /Change /TN "ScreenshotCleaner9AM" /ST 15:00
```

### 時刻の指定方法
- 午前3時: `03:00`
- 午後3時: `15:00`
- 午後11時: `23:00`

## 🔧 トラブルシューティング

### Q: 文字化けする
A: `FIX_NOW.bat` を実行してください

### Q: インストールできない
A: 
1. `setup.bat` を右クリック
2. 「管理者として実行」を選択

### Q: 動作確認したい
A: `test.bat` をダブルクリック

### Q: アンインストールしたい
A: `uninstall.bat` をダブルクリック

## 📝 ファイル説明
```
ScreenshotCleaner_Easy/
├── FIX_NOW.bat    ← 最初に実行（修正用）
├── setup.bat      ← インストール
├── test.bat       ← テスト実行
├── status.bat     ← 状態確認
└── uninstall.bat  ← アンインストール
```

## ✅ 正常動作の確認方法
`status.bat` を実行して以下が表示されればOK：
- Task is registered
- Script file exists
- Next Run Time: （次回実行時刻）

## 📞 サポート
問題が発生した場合は、GitHubのIssuesに報告してください。