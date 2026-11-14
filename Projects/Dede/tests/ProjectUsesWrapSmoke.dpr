program ProjectUsesWrapSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, DeDePProject;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  PascalFile, DFMFile: string;
begin
  PascalFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'uses-wrap-smoke.pas';
  DFMFile := ChangeFileExt(PascalFile, '.dfm');
  InitNewProject;
  USES_LIST := 'A,B,C,D,E,F';
  try
    EndProject(PascalFile);
    Require(USES_LIST = 'A,B,C,D,E,' + #13#10 + 'F',
      'Uses-list line wrapping did not start after the fifth comma');
  finally
    DeleteFile(PascalFile);
    DeleteFile(DFMFile);
  end;
  WriteLn('Project uses-wrap smoke test passed');
end.
