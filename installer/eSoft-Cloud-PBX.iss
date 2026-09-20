#define MyAppName "eSoft Cloud PBX"
#define MyAppVersion "3.22.3"
#define MyAppPublisher "eSoft"
#define MyAppExeName "eSoft-Cloud-PBX.exe"

[Setup]
AppId={{7D7E6E75-5F8C-4B0A-E5CF-3223}
AppName={#MyAppName}
AppVerName={#MyAppName} {#MyAppVersion}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://pbx.esoftbd.net
AppSupportURL=https://pbx.esoftbd.net
DefaultDirName={autopf}\eSoft Cloud PBX
DefaultGroupName=eSoft Cloud PBX
OutputDir=..\artifacts
OutputBaseFilename=eSoft-Cloud-PBX-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=..\artifacts\eSoft-Cloud-PBX-installer.ico
WizardImageFile=..\artifacts\eSoft-Cloud-PBX-wizard.bmp
UninstallDisplayIcon={app}\eSoft-Cloud-PBX.exe
PrivilegesRequired=admin
DisableProgramGroupPage=yes

[InstallDelete]
Type: filesandordirs; Name: "{userappdata}\eSoft Cloud PBX"
Type: filesandordirs; Name: "{localappdata}\eSoft Cloud PBX"
Type: files; Name: "{autodesktop}\eSoft Cloud PBX.lnk"

[Files]
Source: "..\artifacts\eSoft-Cloud-PBX.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\artifacts\eSoft-Cloud-PBX-installer.ico"; DestDir: "{app}"; DestName: "eSoft-Cloud-PBX.ico"; Flags: ignoreversion
Source: "..\artifacts\vc_redist.x86.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{autodesktop}\eSoft Cloud PBX"; Filename: "{app}\eSoft-Cloud-PBX.exe"; IconFilename: "{app}\eSoft-Cloud-PBX.ico"; IconIndex: 0
Name: "{group}\eSoft Cloud PBX"; Filename: "{app}\eSoft-Cloud-PBX.exe"; IconFilename: "{app}\eSoft-Cloud-PBX.ico"; IconIndex: 0

[Registry]
Root: HKCU; Subkey: "Software\eSoft Cloud PBX"; ValueType: string; ValueName: ""; ValueData: "{app}"; Flags: uninsdeletekey

[Run]
Filename: "{tmp}\vc_redist.x86.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Microsoft Visual C++ Runtime..."; Flags: waituntilterminated
Filename: "{app}\eSoft-Cloud-PBX.exe"; Description: "Launch eSoft Cloud PBX"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C taskkill /F /IM eSoft-Cloud-PBX.exe /T >nul 2>&1"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C taskkill /F /IM BD-PBX.exe /T >nul 2>&1"; Flags: runhidden waituntilterminated
Filename: "{cmd}"; Parameters: "/C taskkill /F /IM MicroSIP.exe /T >nul 2>&1"; Flags: runhidden waituntilterminated

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
Type: filesandordirs; Name: "{userappdata}\eSoft Cloud PBX"
Type: filesandordirs; Name: "{localappdata}\eSoft Cloud PBX"
Type: filesandordirs; Name: "{userappdata}\BD PBX"
Type: filesandordirs; Name: "{localappdata}\BD PBX"

[Code]
function RunHidden(const FileName, Params: String): Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec(FileName, Params, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

function InitializeSetup(): Boolean;
begin
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM eSoft-Cloud-PBX.exe /T >nul 2>&1');
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM BD-PBX.exe /T >nul 2>&1');
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM MicroSIP.exe /T >nul 2>&1');
  RunHidden(ExpandConstant('{sys}\reg.exe'), 'delete "HKCU\Software\eSoft Cloud PBX" /f');
  RunHidden(ExpandConstant('{sys}\reg.exe'), 'delete "HKCU\Software\BD-PBX" /f');
  RunHidden(ExpandConstant('{sys}\reg.exe'), 'delete "HKCU\Software\BD PBX" /f');
  Result := True;
end;

function InitializeUninstall(): Boolean;
begin
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM eSoft-Cloud-PBX.exe /T >nul 2>&1');
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM BD-PBX.exe /T >nul 2>&1');
  RunHidden(ExpandConstant('{cmd}'), '/C taskkill /F /IM MicroSIP.exe /T >nul 2>&1');
  Result := True;
end;
