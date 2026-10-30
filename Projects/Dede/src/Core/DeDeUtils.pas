unit DeDeUtils;

interface

uses
  SysUtils
{$IFDEF MSWINDOWS}
  , Windows
{$ENDIF}
  ;



  //��ó���汾��Ϣ
  function GetAppVersion(AppName: string;
    var ProductVersion, FileVersion: string): Boolean;



implementation




function GetAppVersion(AppName: string; var ProductVersion, FileVersion: string): Boolean;
{$IFDEF MSWINDOWS}
var
  versionsize, ValueSize: Cardinal;
  VersionBuf, VersionValue: pChar;
{$ENDIF}
begin
  Result := False;
{$IFDEF MSWINDOWS}
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
{$ENDIF}
end;


end.
