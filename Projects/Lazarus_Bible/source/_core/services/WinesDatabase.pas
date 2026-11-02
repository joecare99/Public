unit WinesDatabase;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

function FindWinesDataDir: string;

implementation

uses
  SysUtils;

function FindWinesDataDir: string;
var
  Dir: string;
  Candidate: string;
  I: Integer;
begin
  Dir := ExtractFilePath(ParamStr(0));
  for I := 0 to 8 do
  begin
    Candidate := IncludeTrailingPathDelimiter(Dir) + 'Data' + PathDelim + 'Wines';
    if DirectoryExists(Candidate) then
      Exit(Candidate);
    Dir := ExtractFileDir(ExcludeTrailingPathDelimiter(Dir));
  end;
  Candidate := IncludeTrailingPathDelimiter(GetCurrentDir) + 'Data' + PathDelim + 'Wines';
  if DirectoryExists(Candidate) then
    Exit(Candidate);
  raise Exception.Create('Data' + PathDelim + 'Wines not found');
end;

end.
