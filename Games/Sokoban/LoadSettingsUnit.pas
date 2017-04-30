unit LoadSettingsUnit;

interface

uses MainUnit, INIFiles, SysUtils;

procedure LoadSettings;

implementation

procedure LoadSettings;
var
  SettingsFile: TIniFile;
begin
  SettingsFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) +
    'settings.ini');
  try
    
  finally
    SettingsFile.Free;
  end;
end;

end.
