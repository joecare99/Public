unit DeDeUtils;

interface

uses
  Windows, SysUtils;



  //��ó���汾��Ϣ
  function GetAppVersion(AppName: string;
    var ProductVersion, FileVersion: string): Boolean;



implementation




function GetAppVersion(AppName: string; var ProductVersion, FileVersion: string): Boolean;
var
  versionsize, ValueSize: Cardinal;
  VersionBuf, VersionValue: pChar;

begin
  Result := False;
  if Trim(AppName) = '' then exit;
  versionsize := GetFileVersionInfoSize(Pchar(AppName), VersionSize);
  if VersionSize = 0 then exit;
  VersionBuf := AllocMem(VersionSize);
  try
    GetFileVersionInfo(PChar(AppName), 0, Versionsize, VersionBuf);

    if VerQueryValue(VersionBuf,
      Pchar('\StringFileInfo\040904E4\ProductVersion'),
      Pointer(VersionValue),
      Valuesize) then
    ProductVersion := VersionValue;

    if VerQueryValue(VersionBuf,
      Pchar('\StringFileInfo\040904E4\FileVersion'),
      Pointer(VersionValue),
      Valuesize) then
    FileVersion := VersionValue;
    Result := True;
  finally
    FreeMem(VersionBuf);
  end;

end;


end.
