program DeDeCLI;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeCore, DeDeCoreServices;

procedure WriteUsage;
begin
  Writeln('Usage: dede-cli <binary> --output <directory> [options]');
  Writeln('Options:');
  Writeln('  --pas       Write reconstructed Pascal units');
  Writeln('  --dfm       Write form resources');
  Writeln('  --dpr       Write a Delphi project file');
  Writeln('  --txt       Write event RVA listing');
  Writeln('  --all       Write all project files (default)');
  Writeln('  --force     Replace existing output files');
  Writeln('  --help      Show this help');
end;

function Run: Integer;
var
  I: Integer;
  InputFile, OutputDirectory, Argument: string;
  ExplicitFileTypes, Force: Boolean;
  Options: TDeDeExportOptions;
  Session: TDeDeAnalysisSession;
  Analysis: TDeDeAnalysisResult;
  GeneratedFiles: TStringList;
begin
  Result := 0;
  InputFile := '';
  OutputDirectory := '';
  ExplicitFileTypes := False;
  Force := False;
  Options.IncludeDFM := True;
  Options.IncludePAS := True;
  Options.IncludeDPR := True;
  Options.IncludeEventRVA := True;
  Options.IncludeAnalysisReport := True;

  I := 1;
  while I <= ParamCount do
  begin
    Argument := ParamStr(I);
    if Argument = '--help' then
    begin
      WriteUsage;
      Exit(0);
    end
    else if Argument = '--output' then
    begin
      Inc(I);
      if I > ParamCount then
      begin
        Writeln(ErrOutput, 'Missing directory after --output');
        WriteUsage;
        Exit(2);
      end;
      OutputDirectory := ParamStr(I);
    end
    else if Argument = '--force' then
      Force := True
    else if Argument = '--all' then
    begin
      Options.IncludeDFM := True;
      Options.IncludePAS := True;
      Options.IncludeDPR := True;
      Options.IncludeEventRVA := True;
      ExplicitFileTypes := True;
    end
    else if (Argument = '--pas') or (Argument = '--dfm') or
      (Argument = '--dpr') or (Argument = '--txt') then
    begin
      if not ExplicitFileTypes then
      begin
        Options.IncludeDFM := False;
        Options.IncludePAS := False;
        Options.IncludeDPR := False;
        Options.IncludeEventRVA := False;
        ExplicitFileTypes := True;
      end;
      if Argument = '--pas' then
        Options.IncludePAS := True
      else if Argument = '--dfm' then
        Options.IncludeDFM := True
      else if Argument = '--dpr' then
        Options.IncludeDPR := True
      else
        Options.IncludeEventRVA := True;
    end
    else if (Argument <> '') and (Argument[1] = '-') then
    begin
      Writeln(ErrOutput, 'Unknown option: ', Argument);
      WriteUsage;
      Exit(2);
    end
    else if InputFile = '' then
      InputFile := Argument
    else
    begin
      Writeln(ErrOutput, 'Only one input binary may be specified');
      WriteUsage;
      Exit(2);
    end;
    Inc(I);
  end;

  if InputFile = '' then
  begin
    Writeln(ErrOutput, 'An input binary is required');
    WriteUsage;
    Exit(2);
  end;
  if OutputDirectory = '' then
  begin
    Writeln(ErrOutput, '--output is required');
    WriteUsage;
    Exit(2);
  end;

  Session := TDeDeAnalysisSession.Create;
  GeneratedFiles := nil;
  try
    try
      Analysis := Session.Analyze(InputFile);
      GeneratedFiles := Session.ExportProject(OutputDirectory, Options, Force);
      Writeln('Analyzed ', Analysis.InputFile, ' (', Analysis.CompilerVersion,
        '): ', Analysis.ClassCount, ' classes, ', Analysis.FormCount,
        ' forms, ', GeneratedFiles.Count, ' output files.');
    except
      on E: Exception do
      begin
        Writeln(ErrOutput, 'dede-cli: ', E.Message);
        Result := 1;
      end;
    end;
  finally
    GeneratedFiles.Free;
    Session.Free;
  end;
end;

begin
  Halt(Run);
end.
