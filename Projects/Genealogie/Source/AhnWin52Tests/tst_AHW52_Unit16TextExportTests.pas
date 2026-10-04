unit tst_AHW52_Unit16TextExportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit16TextExport = class(TTestCase)
  published
    procedure TestTextExportUsesTable14FieldsAndHeader;
    procedure TestHtmlExportPreservesListingLines;
    procedure TestHtmlAncestorHeadingEmitsBreakLines;
    procedure TestListCaptionSelectsTable22;
    procedure TestBaseReportSelectsTable27;
    procedure TestHtmlDetectionIsCaseSensitiveSubstringMatch;
    procedure TestMissingDatasetIsReportedAndWriterClosed;
    procedure TestMissingFieldIsReportedAndWriterClosed;
    procedure TestWriterFailureStillClosesWriter;
    procedure TestTextFileWriterWritesAndCloses;
  end;

implementation

uses
  Classes, DB, BufDataset, SysUtils, Unit16TextExportWorkflow;

type
  TCollectingTextWriter = class(TInterfacedObject, IUnit16TextExportWriter)
  private
    FClosed: Boolean;
    FFailOnWrite: Boolean;
  public
    Lines: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure WriteLine(const Value: string);
    procedure Close;
    property Closed: Boolean read FClosed;
    property FailOnWrite: Boolean read FFailOnWrite write FFailOnWrite;
  end;

constructor TCollectingTextWriter.Create;
begin
  inherited Create;
  Lines := TStringList.Create;
end;

destructor TCollectingTextWriter.Destroy;
begin
  Lines.Free;
  inherited Destroy;
end;

procedure TCollectingTextWriter.WriteLine(const Value: string);
begin
  if FFailOnWrite then
    raise Exception.Create('Synthetic writer failure.');
  if FClosed then
    raise EInvalidOperation.Create('The export writer is closed.');
  Lines.Add(Value);
end;

procedure TCollectingTextWriter.Close;
begin
  FClosed := True;
end;

function CreateDataSet(const FieldNames: array of string;
  const Values: array of string): TBufDataset;
var
  fieldIndex: Integer;
begin
  if Length(FieldNames) <> Length(Values) then
    raise EArgumentException.Create('Field and value counts must match.');

  Result := TBufDataset.Create(nil);
  try
    for fieldIndex := 0 to High(FieldNames) do
      Result.FieldDefs.Add(FieldNames[fieldIndex], ftString, 100);
    Result.CreateDataset;
    Result.Open;
    Result.Append;
    for fieldIndex := 0 to High(FieldNames) do
      Result.FieldByName(FieldNames[fieldIndex]).AsString :=
        Values[fieldIndex];
    Result.Post;
  except
    Result.Free;
    raise;
  end;
end;

function CreateContext(const ReportKind, FileName: string):
  TUnit16TextExportContext;
begin
  Result.FileName := FileName;
  Result.ReportKind := ReportKind;
  Result.ReportCaption := '';
  Result.HeaderText02535934 := '';
  Result.HeaderText02535930 := '';
  Result.HeaderText02535438 := '';
  Result.HeaderText0061E028 := '';
end;

function NewTemporaryTextName: string;
var
  fileId: TGUID;
begin
  if CreateGUID(fileId) <> 0 then
    raise Exception.Create('Could not create test output file name.');
  Result := IncludeTrailingPathDelimiter(GetTempDir) +
    'AhnWin52-Unit16-' + GUIDToString(fileId) + '.txt';
end;

procedure TTestAHW52Unit16TextExport.
  TestTextExportUsesTable14FieldsAndHeader;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('NLBO', 'report.txt');
  context.HeaderText02535930 := 'Name list';
  table14 := CreateDataSet(['Nm', 'Zeile'], ['Ada', '1900']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, table14, nil, nil, writer);

    AssertEquals('Name list', writerObject.Lines[0]);
    AssertEquals(StringOfChar('-', 72), writerObject.Lines[1]);
    AssertEquals('Ada 1900', writerObject.Lines[2]);
    AssertEquals(StringOfChar('-', 72), writerObject.Lines[3]);
    AssertTrue(Pos('AHNENWIN 5.1 / ', writerObject.Lines[4]) = 1);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.
  TestHtmlExportPreservesListingLines;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('NLBO', 'report.htm.backup');
  context.HeaderText02535930 := 'Name list';
  table14 := CreateDataSet(['Nm', 'Zeile'], ['Ada', '1900']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, table14, nil, nil, writer);

    AssertEquals('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN//">',
      writerObject.Lines[0]);
    AssertEquals(
      '<!--Converted from AHNENWIN 5.1 (2013) by Heribert Reitmeier-->',
      writerObject.Lines[1]);
    AssertEquals('<HTML>', writerObject.Lines[2]);
    AssertEquals('<BODY>', writerObject.Lines[3]);
    AssertEquals('Name list', writerObject.Lines[4]);
    AssertEquals(StringOfChar('-', 72) + '<p>', writerObject.Lines[5]);
    AssertEquals('Ada 1900<p>', writerObject.Lines[6]);
    AssertEquals('</BODY>', writerObject.Lines[9]);
    AssertEquals('</HTML>', writerObject.Lines[10]);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.
  TestHtmlAncestorHeadingEmitsBreakLines;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('Vorf', 'report.htm');
  context.HeaderText02535934 := 'Selected ancestor';
  table14 := CreateDataSet(['Nm', 'Zeile'], ['Ada', '1900']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, table14, nil, nil, writer);

    AssertEquals('Vorfahren von ', writerObject.Lines[4]);
    AssertEquals('<br>', writerObject.Lines[5]);
    AssertEquals(StringOfChar('-', 72), writerObject.Lines[6]);
    AssertEquals('<br>', writerObject.Lines[7]);
    AssertEquals('Selected ancestor', writerObject.Lines[8]);
    AssertEquals('<br>', writerObject.Lines[9]);
    AssertEquals(StringOfChar('-', 72) + '<p>', writerObject.Lines[10]);
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.TestListCaptionSelectsTable22;
var
  context: TUnit16TextExportContext;
  table22: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('Vorf', 'report.txt');
  context.ReportCaption := 'Namensliste nach Ort';
  context.HeaderText02535934 := 'Selected ancestor';
  table22 := CreateDataSet(['No', 'Zus'], ['17', 'line']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, nil, table22, nil, writer);

    AssertEquals('Namensliste nach Ort', writerObject.Lines[0]);
    AssertEquals('Selected ancestor', writerObject.Lines[2]);
    AssertEquals('17 line', writerObject.Lines[4]);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table22.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.TestBaseReportSelectsTable27;
var
  context: TUnit16TextExportContext;
  table27: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('basa', 'report.txt');
  table27 := CreateDataSet(['Namvorn'], ['Ada Lovelace']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, nil, nil, table27, writer);

    AssertEquals('Ada Lovelace', writerObject.Lines[0]);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table27.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.
  TestHtmlDetectionIsCaseSensitiveSubstringMatch;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
begin
  context := CreateContext('NLAP', 'report.HTM');
  table14 := CreateDataSet(['Nm', 'Zeile'], ['Ada', '1900']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  try
    ExecuteUnit16TextExport(context, table14, nil, nil, writer);

    AssertEquals('Namensliste aller Personen', writerObject.Lines[0]);
    AssertEquals(StringOfChar('-', 72), writerObject.Lines[1]);
    AssertEquals('Ada 1900', writerObject.Lines[2]);
    AssertFalse(writerObject.Lines[0] = '<!DOCTYPE HTML PUBLIC ' +
      '"-//W3C//DTD HTML 4.0//EN//">');
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.
  TestMissingDatasetIsReportedAndWriterClosed;
var
  context: TUnit16TextExportContext;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
  raisedExpectedException: Boolean;
begin
  context := CreateContext('NLBO', 'report.txt');
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  raisedExpectedException := False;
  try
    try
      ExecuteUnit16TextExport(context, nil, nil, nil, writer);
    except
      on EArgumentNilException do
        raisedExpectedException := True;
    end;

    AssertTrue(raisedExpectedException);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
  end;
end;

procedure TTestAHW52Unit16TextExport.
  TestMissingFieldIsReportedAndWriterClosed;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
  raisedExpectedException: Boolean;
begin
  context := CreateContext('NLBO', 'report.txt');
  table14 := CreateDataSet(['WrongField'], ['ignored']);
  writerObject := TCollectingTextWriter.Create;
  writer := writerObject;
  raisedExpectedException := False;
  try
    try
      ExecuteUnit16TextExport(context, table14, nil, nil, writer);
    except
      on EUnit16ExportFieldMissing do
        raisedExpectedException := True;
    end;

    AssertTrue(raisedExpectedException);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.TestWriterFailureStillClosesWriter;
var
  context: TUnit16TextExportContext;
  table14: TBufDataset;
  writerObject: TCollectingTextWriter;
  writer: IUnit16TextExportWriter;
  raisedExpectedException: Boolean;
begin
  context := CreateContext('NLBO', 'report.txt');
  table14 := CreateDataSet(['Nm', 'Zeile'], ['Ada', '1900']);
  writerObject := TCollectingTextWriter.Create;
  writerObject.FailOnWrite := True;
  writer := writerObject;
  raisedExpectedException := False;
  try
    try
      ExecuteUnit16TextExport(context, table14, nil, nil, writer);
    except
      on E: Exception do
        raisedExpectedException := E.Message = 'Synthetic writer failure.';
    end;

    AssertTrue(raisedExpectedException);
    AssertTrue(writerObject.Closed);
  finally
    writer := nil;
    table14.Free;
  end;
end;

procedure TTestAHW52Unit16TextExport.TestTextFileWriterWritesAndCloses;
var
  fileName: string;
  lines: TStringList;
  writer: IUnit16TextExportWriter;
begin
  fileName := NewTemporaryTextName;
  try
    writer := TUnit16TextFileExportWriter.Create(fileName);
    writer.WriteLine('first line');
    writer.WriteLine('second line');
    writer.Close;
    writer := nil;

    lines := TStringList.Create;
    try
      lines.LoadFromFile(fileName);
      AssertEquals(2, lines.Count);
      AssertEquals('first line', lines[0]);
      AssertEquals('second line', lines[1]);
    finally
      lines.Free;
    end;
  finally
    if FileExists(fileName) then
      DeleteFile(fileName);
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit16TextExport);

end.
