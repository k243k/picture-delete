; GalleryCleaner インストーラスクリプト
; Inno Setup 6用

#define MyAppName "GalleryCleaner"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "GalleryCleaner"
#define MyAppURL "https://example.com"

[Setup]
AppId={{A7B3C4D5-E6F7-8901-2345-6789ABCDEF01}
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
OutputBaseFilename=GalleryCleanerSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\clean.ps1
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
Source: "clean.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "register_task.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "uninstall.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "README_jp.md"; DestDir: "{app}"; Flags: ignoreversion

[Run]
Filename: "{app}\register_task.bat"; StatusMsg: "タスクスケジューラに登録中..."; Flags: runhidden waituntilterminated
Filename: "schtasks"; Parameters: "/Run /TN ""GalleryCleaner9AM"""; StatusMsg: "テスト実行中..."; Flags: runhidden postinstall skipifsilent unchecked; Description: "今すぐテスト実行（ドライラン）"

[UninstallRun]
Filename: "{app}\uninstall.bat"; Flags: runhidden waituntilterminated

[Messages]
japanese.BeveledLabel=日本語

[CustomMessages]
japanese.InstallingLabel=GalleryCleanerをインストール中...
japanese.FinishedLabel=インストールが完了しました

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  MsgBox('GalleryCleanerをインストールします。' + #13#10 + 
         '毎朝9:00に画像ファイルをゴミ箱へ移動します。' + #13#10 + 
         '※完全削除ではありません。', mbInformation, MB_OK);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox('インストールが完了しました。' + #13#10 + 
           '明日の朝9:00から自動実行されます。' + #13#10 + 
           '今すぐテストする場合は「完了」後のオプションを選択してください。', 
           mbInformation, MB_OK);
  end;
end;