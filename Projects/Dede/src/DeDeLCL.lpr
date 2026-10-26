program DeDeLCL;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, Forms, SysUtils, LCLMainUnit;

var
  MainForm: TDeDeLCLMainForm;
  ExitCode: Integer;

function RunSmoke(const AInputFile, AOutputDirectory: string): Integer;
var
  SmokeForm: TDeDeLCLMainForm;
begin
  Application.Initialize;
  RequireDerivedFormResource := False;
  SmokeForm := TDeDeLCLMainForm.Create(nil);
  try
    SmokeForm.SetPaths(AInputFile, AOutputDirectory);
    SmokeForm.Show;
    Application.ProcessMessages;
    if not SmokeForm.RunAnalysis then
    begin
      Writeln(ErrOutput, 'LCL smoke failed: ', SmokeForm.LastError);
      Exit(1);
    end;
    Application.ProcessMessages;
    Writeln('LCL smoke passed: ', AOutputDirectory);
    Result := 0;
  finally
    SmokeForm.Free;
  end;
end;

begin
  if (ParamCount > 0) and (ParamStr(1) = '--smoke') then
  begin
    if ParamCount <> 3 then
    begin
      Writeln(ErrOutput, 'Usage: DeDeLCL --smoke <binary> <output-directory>');
      Halt(2);
    end;
    ExitCode := RunSmoke(ParamStr(2), ParamStr(3));
    Halt(ExitCode);
  end;

  Application.Initialize;
  RequireDerivedFormResource := False;
  Application.Title := 'DeDe';
  Application.CreateForm(TDeDeLCLMainForm, MainForm);
  Application.Run;
end.
