unit SettingsUnit;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses MainUnit, INIFiles, SysUtils, Forms{$IFDEF FPC}, FileUtil{$ENDIF};

procedure LoadSettings;
procedure SaveSettings;
procedure LoadDefaultSettings;
function GetDataDir: string;
function GetSettingsDir: string;

implementation

resourcestring
  SBaseDir = 'Data';
  SSettingFile = 'settings.ini';
  SGeneralSection = 'General';

var
  FDataDir, FSettingsDir: string;

{$IFNDEF FPC}
  const
    DirectorySeparator=PathDelim;
{$ENDIF}

procedure LoadSettings;
var
  SettingsFileName: TFileName;
  SettingsFile: TIniFile;
  LLevelNumber: longint;
  LDataDir: string;
begin
  SettingsFileName := FsettingsDir + SSettingFile;
  if FileExists(SettingsFileName) then
  begin
    SettingsFile := TIniFile.Create(SettingsFileName);
    try
      if SettingsFile.ReadInteger(SGeneralSection, 'StatusbarVisible', 1) = 0 then
        frmSokoban.ActStatusBar.Execute;
      if SettingsFile.ReadInteger(SGeneralSection, 'StandardBarVisible',
        1) = 0 then
        frmSokoban.ShowHideStandardAction.Execute;
      LLevelNumber := SettingsFile.ReadInteger(SGeneralSection, 'ActiveLevel', 1);
      LDataDir := SettingsFile.ReadString(SGeneralSection, 'DataDir', FdataDir);
      if DirectoryExists(LDataDir) then
        FDataDir := LDataDir;
      FSkinFileName := SettingsFile.ReadString(SGeneralSection,
        'ActiveSkin', ExtractFilePath(ParamStr(0)) + 'Skins\Jumanji\Jumanji.ini');
      FLevelFileName := SettingsFile.ReadString(SGeneralSection,
        'ActiveLevelSet', ExtractFilePath(ParamStr(0)) + 'Levels\Original.slc');
      frmSokoban.Width := SettingsFile.ReadInteger(SGeneralSection,
        'WindowWidth', 660);
      frmSokoban.Height :=
        SettingsFile.ReadInteger(SGeneralSection, 'WindowHeight', 550);
      if SettingsFile.ReadInteger(SGeneralSection, 'WindowMaximized', 0) = 1 then
        frmSokoban.WindowState := wsMaximized;
      frmsokoban.LevelNumber := LLevelNumber;
    finally
      SettingsFile.Free;
    end;
  end
  else
  begin
    LoadDefaultSettings;
    SaveSettings;
  end;
end;

procedure LoadDefaultSettings;
begin
  FSkinFileName := FDataDir + 'Skins\Jumanji\Jumanji.ini';
  FLevelFileName := FDataDir + 'Levels\Original.slc';
  frmSokoban.WindowState := wsNormal;
  frmSokoban.Width := 660;
  frmSokoban.Height := 550;
  frmSokoban.LevelNumber := 1;
end;

function GetDataDir: string;
begin
  Result := FDataDir;
end;

function GetSettingsDir: string;
begin
  Result := FSettingsDir;
end;

procedure SaveSettings;
var
  SettingsFileName: TFileName;
  SettingsFile: TIniFile;
begin
  SettingsFileName := FsettingsDir + SSettingFile;
  SettingsFile := TIniFile.Create(SettingsFileName);
  try
    if frmSokoban.StatusBar.Visible then
      SettingsFile.WriteInteger(SGeneralSection, 'StatusbarVisible', 1)
    else
      SettingsFile.WriteInteger(SGeneralSection, 'StatusbarVisible', 0);

    if frmSokoban.WindowState = wsMaximized then
      SettingsFile.WriteInteger(SGeneralSection, 'WindowMaximized', 1)
    else
    begin
      SettingsFile.WriteInteger(SGeneralSection, 'WindowMaximized', 0);
      SettingsFile.WriteInteger(SGeneralSection, 'WindowWidth', frmSokoban.Width);
      SettingsFile.WriteInteger(SGeneralSection, 'WindowHeight',
        frmSokoban.Height);
    end;

    if frmSokoban.StandardBar.Visible then
      SettingsFile.WriteInteger(SGeneralSection, 'StandardBarVisible', 1)
    else
      SettingsFile.WriteInteger(SGeneralSection, 'StandardBarVisible', 0);

    SettingsFile.WriteInteger(SGeneralSection, 'ActiveLevel', frmSokoban.LevelNumber);
    SettingsFile.WriteString(SGeneralSection, 'DataDir', FDataDir);
    SettingsFile.WriteString(SGeneralSection, 'ActiveSkin', FSkinFileName);
    SettingsFile.WriteString(SGeneralSection, 'ActiveLevelSet', FLevelFileName);
  finally
    SettingsFile.Free;
  end;
end;

var
  i: integer;

initialization
  if FileExists(ExtractFilePath(ParamStr(0)) + SSettingFile) then
    FsettingsDir := ExtractFilePath(ParamStr(0))
  {$IFDEF MSWINDOWS}
  else if FileExists(GetEnvironmentVariable('APPDATA') + DirectorySeparator +
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator + SSettingFile) then
    FsettingsDir := GetEnvironmentVariable('APPDATA') + DirectorySeparator +
      ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator
  else
  begin
    FsettingsDir := GetEnvironmentVariable('APPDATA') + DirectorySeparator +
      ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator;
    if not DirectoryExists(FSettingsDir) then
      CreateDir(FSettingsDir);
  end;
  {$ELSE}
  else if FileExists(GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
    ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator + SSettingFile) then
    FsettingsDir := GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
      ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator
  else
  begin
    FsettingsDir := GetEnvironmentVariable('HOME')+ DirectorySeparator +'.'+
      ChangeFileExt(ExtractFilename(ParamStr(0)), '') + DirectorySeparator;
    if not DirectoryExists(FSettingsDir) then
      CreateDir(FSettingsDir);
  end;
  {$ENDIF}
  FDataDir := SBaseDir;
  for i := 0 to 2 do
    if DirectoryExists(FDataDir) then
      break
    else
      FDataDir := '..' + DirectorySeparator + FDataDir;
end.
