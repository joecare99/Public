unit Unit18SaveWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Unit18ExportWorkflow, Unit18SaveDialogWorkflow;

function RunUnit18SaveWorkflow(Dialog: IUnit18SaveDialog;
  SourceFactory: IUnit18ExportSourceFactory;
  WriterFactory: IUnit18TextWriterFactory;
  NormalizeDeathDate: TUnit18ExportNormalizer): Boolean;

implementation

function RunUnit18SaveWorkflow(Dialog: IUnit18SaveDialog;
  SourceFactory: IUnit18ExportSourceFactory;
  WriterFactory: IUnit18TextWriterFactory;
  NormalizeDeathDate: TUnit18ExportNormalizer): Boolean;
var
  Writer: IUnit18TextWriter;
  Source: IUnit18ExportSource;
begin
  if Dialog = nil then
    raise EUnit18SaveDialogArgumentError.Create('Dialog must not be nil.');

  if not PrepareUnit18SavePath(Dialog) then
  begin
    Result := False;
    Exit;
  end;

  if SourceFactory = nil then
    raise EUnit18ExportArgumentError.Create(
      'SourceFactory must not be nil.');
  if WriterFactory = nil then
    raise EUnit18ExportArgumentError.Create(
      'WriterFactory must not be nil.');

  Writer := WriterFactory.CreateWriter(Dialog.GetFileName);
  if Writer = nil then
    raise EUnit18ExportArgumentError.Create(
      'WriterFactory returned no writer.');
  try
    Source := SourceFactory.CreateSource;
    WriteUnit18ExportFile(Source, Writer, NormalizeDeathDate);
    Result := True;
  finally
    Writer.Close;
  end;
end;

end.
