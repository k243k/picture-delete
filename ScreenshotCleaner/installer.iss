; ScreenshotCleaner インストーラスクリプト
; Inno Setup 6用

#define MyAppName "ScreenshotCleaner"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "ScreenshotCleaner"
#define MyAppURL "https://example.com"

[Setup]
AppId={{B8C4D6E7-F8G9-0123-4567-890ABCDEF123}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputBaseFilename=ScreenshotCleanerSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\clean_screenshots.ps1
ArchitecturesAllowed=x64 x86
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=
DisableWelcomePage=no
DisableDirPage=no
DisableReadyPage=no
ShowLanguageDialog=no

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Files]
Source: "clean_screenshots.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "register_task.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "uninstall.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "README_jp.md"; DestDir: "{app}"; Flags: ignoreversion

[Run]
Filename: "{app}\register_task.bat"; StatusMsg: "タスクスケジューラに登録中..."; Flags: runhidden waituntilterminated
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\clean_screenshots.ps1"" -WhatIf"; StatusMsg: "ドライランを実行中..."; Flags: runhidden postinstall skipifsilent unchecked; Description: "今すぐドライランでテスト（削除せず確認のみ）"

[UninstallRun]
Filename: "{app}\uninstall.bat"; Flags: runhidden waituntilterminated

[Messages]
japanese.BeveledLabel=日本語

[CustomMessages]
japanese.InstallingLabel=ScreenshotCleanerをインストール中...
japanese.FinishedLabel=インストールが完了しました

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  Result := True;
  
  if MsgBox('ScreenshotCleanerをインストールします。' + #13#10 + #13#10 +
            '⚠️ 重要な警告:' + #13#10 +
            'このツールは毎朝9:00にスクリーンショットを' + #13#10 +
            '完全削除します（復元不可能）。' + #13#10 + #13#10 +
            '続行しますか？', 
            mbConfirmation, MB_YESNO) = IDNO then
  begin
    Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox('インストールが完了しました。' + #13#10 + #13#10 +
           '⚠️ 重要:' + #13#10 +
           '• 明日の朝9:00から自動実行されます' + #13#10 +
           '• スクリーンショットは完全削除されます' + #13#10 +
           '• 削除されたファイルは復元できません' + #13#10 + #13#10 +
           '必ず「ドライラン」でテストしてください。', 
           mbInformation, MB_OK);
  end;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
  MsgBox('ScreenshotCleanerをアンインストールします。' + #13#10 +
         'タスクスケジューラの登録も削除されます。', 
         mbInformation, MB_OK);
end;