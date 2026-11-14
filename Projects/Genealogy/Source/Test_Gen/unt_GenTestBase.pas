unit unt_GenTestBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function GetDataPath(aSubPath:String): string;

implementation

function GetDataPath(aSubPath:String): string;
var
  i: integer;
begin
  Result := 'Data';
  for i := 0 to 2 do
      if DirectoryExists(Result) then
          break
      else
          Result := '..' + DirectorySeparator + Result;
  if not DirectoryExists(Result) then
      Result := GetAppConfigDir(True)
  else
      Result := Result + DirectorySeparator + aSubPath;
  if not DirectoryExists(Result) then
      ForceDirectories(Result);
end;


end.

