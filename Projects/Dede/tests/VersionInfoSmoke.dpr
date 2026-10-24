program VersionInfoSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, DeDeUtils;

var
  ProductVersion, FileVersion: string;
begin
  if ParamCount <> 1 then
    raise EArgumentException.Create('Pass a PE file path');
  if not GetAppVersion(ParamStr(1), ProductVersion, FileVersion) then
    raise Exception.Create('Could not read version information');
  if (ProductVersion <> '3.10b') or (FileVersion <> '3.1.0.1619') then
    raise Exception.CreateFmt('Unexpected versions: product=%s file=%s',
      [ProductVersion, FileVersion]);
  WriteLn('Version resource smoke test passed');
end.
