unit tst_AHW52_Unit18SaveDialogWorkflowTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit18SaveDialogWorkflow = class(TTestCase)
  published
    procedure TestCancellationStopsAfterFilterIndex;
    procedure TestAcceptedTextPathPreservesExtension;
    procedure TestAcceptedPathWithoutExtensionAddsTextExtension;
    procedure TestExtensionCheckIsCaseSensitiveAndUsesFileExtension;
    procedure TestAcceptedWorkflowWritesHeaderAndClosesWriter;
    procedure TestCancelledWorkflowCreatesNoSourceOrWriter;
    procedure TestFormSaveUsesInjectedWorkflowWithoutDialogOrFile;
  end;

implementation

uses
  Classes, SysUtils, Unit18, Unit18ExportWorkflow,
  Unit18SaveDialogWorkflow, Unit18SaveWorkflow;

type
  TFakeUnit18SaveDialog = class(TInterfacedObject, IUnit18SaveDialog)
  public
    Accepted: Boolean;
    CurrentFileName: string;
    CurrentFilterIndex: Integer;
    CurrentDefaultExt: string;
    Calls: string;
    FilterIndexWhenExecuted: Integer;
    DefaultExtWhenExecuted: string;
    procedure SetFilterIndex(Value: Integer);
    function Execute: Boolean;
    procedure SetDefaultExt(const Value: string);
    function GetFileName: string;
    procedure SetFileName(const Value: string);
  end;

  TEmptyUnit18ExportSource = class(TInterfacedObject, IUnit18ExportSource)
  public
    procedure First;
    function EOF: Boolean;
    function CurrentRow: TUnit18ExportRow;
    procedure Next;
  end;

  TFakeUnit18ExportSourceFactory = class(TInterfacedObject,
    IUnit18ExportSourceFactory)
  public
    CreateCount: Integer;
    function CreateSource: IUnit18ExportSource;
  end;

  TCollectingUnit18TextWriter = class(TInterfacedObject, IUnit18TextWriter)
  public
    Lines: TStringList;
    Closed: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure WriteLine(const LineText: string);
    procedure Close;
  end;

  TFakeUnit18TextWriterFactory = class(TInterfacedObject,
    IUnit18TextWriterFactory)
  private
    FWriter: IUnit18TextWriter;
  public
    FileName: string;
    Writer: TCollectingUnit18TextWriter;
    CreateCount: Integer;
    function CreateWriter(const OutputFileName: string): IUnit18TextWriter;
  end;

  TTestableUnit18Form = class(TForm18)
  public
    DialogBoundary: IUnit18SaveDialog;
    SourceFactory: IUnit18ExportSourceFactory;
    WriterFactory: IUnit18TextWriterFactory;
  protected
    function CreateSaveDialogBoundary: IUnit18SaveDialog; override;
    function CreateExportSourceFactory: IUnit18ExportSourceFactory; override;
    function CreateTextWriterFactory: IUnit18TextWriterFactory; override;
  end;

procedure TFakeUnit18SaveDialog.SetFilterIndex(Value: Integer);
begin
  Calls := Calls + 'F';
  CurrentFilterIndex := Value;
end;

function TFakeUnit18SaveDialog.Execute: Boolean;
begin
  Calls := Calls + 'E';
  FilterIndexWhenExecuted := CurrentFilterIndex;
  DefaultExtWhenExecuted := CurrentDefaultExt;
  Result := Accepted;
end;

procedure TFakeUnit18SaveDialog.SetDefaultExt(const Value: string);
begin
  Calls := Calls + 'D';
  CurrentDefaultExt := Value;
end;

function TFakeUnit18SaveDialog.GetFileName: string;
begin
  Calls := Calls + 'G';
  Result := CurrentFileName;
end;

procedure TFakeUnit18SaveDialog.SetFileName(const Value: string);
begin
  Calls := Calls + 'S';
  CurrentFileName := Value;
end;

procedure TEmptyUnit18ExportSource.First;
begin
end;

function TEmptyUnit18ExportSource.EOF: Boolean;
begin
  Result := True;
end;

function TEmptyUnit18ExportSource.CurrentRow: TUnit18ExportRow;
begin
  raise Exception.Create('An empty source has no current row.');
end;

procedure TEmptyUnit18ExportSource.Next;
begin
  raise Exception.Create('An empty source cannot advance.');
end;

function TFakeUnit18ExportSourceFactory.CreateSource:
  IUnit18ExportSource;
begin
  Inc(CreateCount);
  Result := TEmptyUnit18ExportSource.Create;
end;

constructor TCollectingUnit18TextWriter.Create;
begin
  inherited Create;
  Lines := TStringList.Create;
end;

destructor TCollectingUnit18TextWriter.Destroy;
begin
  Lines.Free;
  inherited Destroy;
end;

procedure TCollectingUnit18TextWriter.WriteLine(const LineText: string);
begin
  if Closed then
    raise Exception.Create('The fake writer has been closed.');
  Lines.Add(LineText);
end;

procedure TCollectingUnit18TextWriter.Close;
begin
  Closed := True;
end;

function TFakeUnit18TextWriterFactory.CreateWriter(
  const OutputFileName: string): IUnit18TextWriter;
begin
  Inc(CreateCount);
  FileName := OutputFileName;
  Writer := TCollectingUnit18TextWriter.Create;
  FWriter := Writer;
  Result := FWriter;
end;

function TTestableUnit18Form.CreateSaveDialogBoundary:
  IUnit18SaveDialog;
begin
  Result := DialogBoundary;
end;

function TTestableUnit18Form.CreateExportSourceFactory:
  IUnit18ExportSourceFactory;
begin
  Result := SourceFactory;
end;

function TTestableUnit18Form.CreateTextWriterFactory:
  IUnit18TextWriterFactory;
begin
  Result := WriterFactory;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestCancellationStopsAfterFilterIndex;
var
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    Dialog.Accepted := False;
    Dialog.CurrentFileName := 'family';

    AssertFalse(PrepareUnit18SavePath(DialogInterface));
    AssertEquals('FE', Dialog.Calls);
    AssertEquals(1, Dialog.FilterIndexWhenExecuted);
    AssertEquals('', Dialog.CurrentDefaultExt);
    AssertEquals('family', Dialog.CurrentFileName);
  finally
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestAcceptedTextPathPreservesExtension;
var
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    Dialog.Accepted := True;
    Dialog.CurrentFileName := 'family.txt';

    AssertTrue(PrepareUnit18SavePath(DialogInterface));
    AssertEquals('FEDG', Dialog.Calls);
    AssertEquals(1, Dialog.FilterIndexWhenExecuted);
    AssertEquals('', Dialog.DefaultExtWhenExecuted);
    AssertEquals('txt', Dialog.CurrentDefaultExt);
    AssertEquals('family.txt', Dialog.CurrentFileName);
  finally
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestAcceptedPathWithoutExtensionAddsTextExtension;
var
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    Dialog.Accepted := True;
    Dialog.CurrentFileName := 'family';

    AssertTrue(PrepareUnit18SavePath(DialogInterface));
    AssertEquals('FEDGS', Dialog.Calls);
    AssertEquals('family.txt', Dialog.CurrentFileName);
  finally
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestExtensionCheckIsCaseSensitiveAndUsesFileExtension;
var
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    Dialog.Accepted := True;
    Dialog.CurrentFileName := 'family.TXT';
    AssertTrue(PrepareUnit18SavePath(DialogInterface));
    AssertEquals('family.TXT.txt', Dialog.CurrentFileName);

    Dialog.Calls := '';
    Dialog.CurrentFileName := 'family.txt.backup';
    AssertTrue(PrepareUnit18SavePath(DialogInterface));
    AssertEquals('family.txt.backup.txt', Dialog.CurrentFileName);
  finally
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestAcceptedWorkflowWritesHeaderAndClosesWriter;
var
  SourceForm: TTestableUnit18Form;
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
  SourceFactory: TFakeUnit18ExportSourceFactory;
  SourceFactoryInterface: IUnit18ExportSourceFactory;
  WriterFactory: TFakeUnit18TextWriterFactory;
  WriterFactoryInterface: IUnit18TextWriterFactory;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  SourceFactory := TFakeUnit18ExportSourceFactory.Create;
  SourceFactoryInterface := SourceFactory;
  WriterFactory := TFakeUnit18TextWriterFactory.Create;
  WriterFactoryInterface := WriterFactory;
  SourceForm := TTestableUnit18Form.CreateNew(nil);
  try
    SourceForm.DialogBoundary := DialogInterface;
    SourceForm.SourceFactory := SourceFactoryInterface;
    SourceForm.WriterFactory := WriterFactoryInterface;
    Dialog.Accepted := True;
    Dialog.CurrentFileName := 'synthetic-family';

    SourceForm.speichern(SourceForm);
    AssertEquals('synthetic-family.txt', Dialog.CurrentFileName);
    AssertEquals('FEDGSG', Dialog.Calls);
    AssertEquals('synthetic-family.txt', WriterFactory.FileName);
    AssertEquals(1, WriterFactory.CreateCount);
    AssertEquals(1, SourceFactory.CreateCount);
    AssertTrue(WriterFactory.Writer.Closed);
    AssertEquals(2, WriterFactory.Writer.Lines.Count);
    AssertEquals(Unit18ExportHeader, WriterFactory.Writer.Lines[0]);
    AssertEquals(' ', WriterFactory.Writer.Lines[1]);
  finally
    SourceForm.Free;
    WriterFactoryInterface := nil;
    SourceFactoryInterface := nil;
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestCancelledWorkflowCreatesNoSourceOrWriter;
var
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    Dialog.Accepted := False;
    Dialog.CurrentFileName := 'synthetic-family';

    AssertFalse(RunUnit18SaveWorkflow(DialogInterface, nil, nil, nil));
    AssertEquals('FE', Dialog.Calls);
  finally
    DialogInterface := nil;
  end;
end;

procedure TTestAHW52Unit18SaveDialogWorkflow.
  TestFormSaveUsesInjectedWorkflowWithoutDialogOrFile;
var
  SourceForm: TTestableUnit18Form;
  Dialog: TFakeUnit18SaveDialog;
  DialogInterface: IUnit18SaveDialog;
begin
  SourceForm := TTestableUnit18Form.CreateNew(nil);
  Dialog := TFakeUnit18SaveDialog.Create;
  DialogInterface := Dialog;
  try
    SourceForm.DialogBoundary := DialogInterface;
    Dialog.Accepted := False;
    Dialog.CurrentFileName := 'synthetic-family';

    SourceForm.speichern(SourceForm);

    AssertEquals('FE', Dialog.Calls);
    AssertEquals('', Dialog.CurrentDefaultExt);
  finally
    SourceForm.Free;
    DialogInterface := nil;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit18SaveDialogWorkflow);

end.
