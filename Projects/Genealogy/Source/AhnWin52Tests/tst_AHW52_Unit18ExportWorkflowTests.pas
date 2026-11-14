unit tst_AHW52_Unit18ExportWorkflowTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit18ExportWorkflow = class(TTestCase)
  published
    procedure TestFormatsAllColumnsInListingOrder;
    procedure TestZeroNumberUsesFiveSpaces;
    procedure TestDataSetAdapterMapsTable16Fields;
    procedure TestNormalizesTheDeathDateBeforeWriting;
    procedure TestUsesTheRecoveredUnit18Normalizer;
    procedure TestWritesHeaderAndSyntheticRow;
    procedure TestEmptySourceWritesHeaderAndSeparator;
    procedure TestTextFileWriterWritesAndCloses;
  end;

implementation

uses
  Classes, DB, MemDS, SysUtils, Unit18, Unit18DataSetExportSource,
  Unit18ExportWorkflow;

type
  TSingleRowExportSource = class(TInterfacedObject, IUnit18ExportSource)
  private
    FRow: TUnit18ExportRow;
    FAtEnd: Boolean;
  public
    constructor Create(const Row: TUnit18ExportRow);
    procedure First;
    function EOF: Boolean;
    function CurrentRow: TUnit18ExportRow;
    procedure Next;
  end;

  TEmptyExportSource = class(TInterfacedObject, IUnit18ExportSource)
  public
    procedure First;
    function EOF: Boolean;
    function CurrentRow: TUnit18ExportRow;
    procedure Next;
  end;

  TCollectingTextWriter = class(TInterfacedObject, IUnit18TextWriter)
  private
    FClosed: Boolean;
  public
    Lines: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure WriteLine(const LineText: string);
    procedure Close;
    property Closed: Boolean read FClosed;
  end;

var
  NormalizedDeathDateInput: AnsiString;

constructor TSingleRowExportSource.Create(const Row: TUnit18ExportRow);
begin
  inherited Create;
  FRow := Row;
  FAtEnd := False;
end;

procedure TSingleRowExportSource.First;
begin
  FAtEnd := False;
end;

function TSingleRowExportSource.EOF: Boolean;
begin
  Result := FAtEnd;
end;

function TSingleRowExportSource.CurrentRow: TUnit18ExportRow;
begin
  Result := FRow;
end;

procedure TSingleRowExportSource.Next;
begin
  FAtEnd := True;
end;

procedure TEmptyExportSource.First;
begin
end;

function TEmptyExportSource.EOF: Boolean;
begin
  Result := True;
end;

function TEmptyExportSource.CurrentRow: TUnit18ExportRow;
begin
  Result.Number := 0;
  raise Exception.Create('An empty source has no current row.');
end;

procedure TEmptyExportSource.Next;
begin
  raise Exception.Create('An empty source cannot advance.');
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

procedure TCollectingTextWriter.WriteLine(const LineText: string);
begin
  if FClosed then
    raise Exception.Create('The fake writer has been closed.');
  Lines.Add(LineText);
end;

procedure TCollectingTextWriter.Close;
begin
  FClosed := True;
end;

procedure PreserveDeathDate(InputText: AnsiString;
  var OutputText: AnsiString);
begin
  OutputText := InputText;
end;

procedure MarkNormalizedDeathDate(InputText: AnsiString;
  var OutputText: AnsiString);
begin
  NormalizedDeathDateInput := InputText;
  OutputText := '<' + InputText + '>';
end;

function CreateSampleRow: TUnit18ExportRow;
begin
  Result.Number := 42;
  Result.Name := 'Beispielperson';
  Result.BirthDay := '1';
  Result.BirthMonth := '2';
  Result.BirthYear := '1900';
  Result.BirthPlace := 'Geburtsort';
  Result.DeathDay := '3';
  Result.DeathMonth := '4';
  Result.DeathYear := '1980';
  Result.DeathPlace := 'Sterbeort';
  Result.HDay := '5';
  Result.HMonth := '6';
  Result.HYear := '1920';
  Result.HPlace := 'Heiratsort';
  Result.HName := 'Ehepartner';
end;

procedure TTestAHW52Unit18ExportWorkflow.TestFormatsAllColumnsInListingOrder;
var
  Row: TUnit18ExportRow;
begin
  Row := CreateSampleRow;
  AssertEquals('   42'#9'Beispielperson'#9'1.2.1900'#9'Geburtsort'#9'3.4.1980'#9 +
    'Sterbeort'#9'5.6.1920'#9'Heiratsort'#9'Ehepartner',
    FormatUnit18ExportRow(Row, @PreserveDeathDate));
end;

procedure TTestAHW52Unit18ExportWorkflow.TestZeroNumberUsesFiveSpaces;
var
  Row: TUnit18ExportRow;
begin
  Row := CreateSampleRow;
  Row.Number := 0;
  AssertTrue('A zero person number is exported as five spaces.',
    Copy(FormatUnit18ExportRow(Row, @PreserveDeathDate), 1, 6) = '     '#9);
end;

procedure TTestAHW52Unit18ExportWorkflow.TestDataSetAdapterMapsTable16Fields;
var
  DataSet: TMemDataset;
  Source: IUnit18ExportSource;
  Row: TUnit18ExportRow;
begin
  DataSet := TMemDataset.Create(nil);
  try
    with DataSet.FieldDefs do
    begin
      Add('Nummer', ftInteger);
      Add('Name', ftString, 40);
      Add('Gebtag', ftString, 2);
      Add('Gebmonat', ftString, 2);
      Add('Gebjahr', ftString, 4);
      Add('Gebort', ftString, 40);
      Add('Sttag', ftString, 2);
      Add('Stmonat', ftString, 2);
      Add('Stjahr', ftString, 4);
      Add('Stort', ftString, 40);
      Add('Htag', ftString, 2);
      Add('Hmonat', ftString, 2);
      Add('Hjahr', ftString, 4);
      Add('Hort', ftString, 40);
      Add('Hname', ftString, 40);
    end;
    DataSet.CreateTable;
    DataSet.Active := True;
    DataSet.Append;
    DataSet.FieldByName('Nummer').AsInteger := 42;
    DataSet.FieldByName('Name').AsString := 'Beispielperson';
    DataSet.FieldByName('Gebtag').AsString := '1';
    DataSet.FieldByName('Gebmonat').AsString := '2';
    DataSet.FieldByName('Gebjahr').AsString := '1900';
    DataSet.FieldByName('Gebort').AsString := 'Geburtsort';
    DataSet.FieldByName('Sttag').AsString := '3';
    DataSet.FieldByName('Stmonat').AsString := '4';
    DataSet.FieldByName('Stjahr').AsString := '1980';
    DataSet.FieldByName('Stort').AsString := 'Sterbeort';
    DataSet.FieldByName('Htag').AsString := '5';
    DataSet.FieldByName('Hmonat').AsString := '6';
    DataSet.FieldByName('Hjahr').AsString := '1920';
    DataSet.FieldByName('Hort').AsString := 'Heiratsort';
    DataSet.FieldByName('Hname').AsString := 'Ehepartner';
    DataSet.Post;

    Source := TUnit18DataSetExportSource.Create(DataSet);
    Source.First;
    AssertFalse(Source.EOF);
    Row := Source.CurrentRow;
    AssertEquals(42, Row.Number);
    AssertEquals('Beispielperson', Row.Name);
    AssertEquals('1', Row.BirthDay);
    AssertEquals('2', Row.BirthMonth);
    AssertEquals('1900', Row.BirthYear);
    AssertEquals('Geburtsort', Row.BirthPlace);
    AssertEquals('3', Row.DeathDay);
    AssertEquals('4', Row.DeathMonth);
    AssertEquals('1980', Row.DeathYear);
    AssertEquals('Sterbeort', Row.DeathPlace);
    AssertEquals('5', Row.HDay);
    AssertEquals('6', Row.HMonth);
    AssertEquals('1920', Row.HYear);
    AssertEquals('Heiratsort', Row.HPlace);
    AssertEquals('Ehepartner', Row.HName);
    Source.Next;
    AssertTrue(Source.EOF);
  finally
    Source := nil;
    DataSet.Free;
  end;
end;

procedure TTestAHW52Unit18ExportWorkflow.
  TestNormalizesTheDeathDateBeforeWriting;
var
  Row: TUnit18ExportRow;
begin
  Row := CreateSampleRow;
  NormalizedDeathDateInput := '';
  AssertTrue(Pos(#9'<3.4.1980>'#9, FormatUnit18ExportRow(Row,
    @MarkNormalizedDeathDate)) > 0);
  AssertEquals('3.4.1980', string(NormalizedDeathDateInput));
end;

procedure TTestAHW52Unit18ExportWorkflow.
  TestUsesTheRecoveredUnit18Normalizer;
var
  Row: TUnit18ExportRow;
begin
  Row := CreateSampleRow;
  AssertEquals('   42'#9'Beispielperson'#9'1.2.1900'#9'Geburtsort'#9 +
    '3.4.1980'#9'Sterbeort'#9'5.6.1920'#9'Heiratsort'#9'Ehepartner',
    FormatUnit18ExportRow(Row, @Proc_00545A0C));
end;

procedure TTestAHW52Unit18ExportWorkflow.TestWritesHeaderAndSyntheticRow;
var
  Source: IUnit18ExportSource;
  Writer: TCollectingTextWriter;
  WriterInterface: IUnit18TextWriter;
begin
  Source := TSingleRowExportSource.Create(CreateSampleRow);
  Writer := TCollectingTextWriter.Create;
  WriterInterface := Writer;
  try
    WriteUnit18ExportFile(Source, WriterInterface, @PreserveDeathDate);
    AssertEquals(3, Writer.Lines.Count);
    AssertEquals(Unit18ExportHeader, Writer.Lines[0]);
    AssertEquals(' ', Writer.Lines[1]);
    AssertEquals('   42'#9'Beispielperson'#9'1.2.1900'#9'Geburtsort'#9 +
      '3.4.1980'#9'Sterbeort'#9'5.6.1920'#9'Heiratsort'#9'Ehepartner',
      Writer.Lines[2]);
    AssertFalse(Writer.Closed);
  finally
    Writer.Close;
    WriterInterface := nil;
    Writer := nil;
    Source := nil;
  end;
end;

procedure TTestAHW52Unit18ExportWorkflow.
  TestEmptySourceWritesHeaderAndSeparator;
var
  Source: IUnit18ExportSource;
  Writer: TCollectingTextWriter;
  WriterInterface: IUnit18TextWriter;
begin
  Source := TEmptyExportSource.Create;
  Writer := TCollectingTextWriter.Create;
  WriterInterface := Writer;
  try
    WriteUnit18ExportFile(Source, WriterInterface, @PreserveDeathDate);
    AssertEquals(2, Writer.Lines.Count);
    AssertEquals(Unit18ExportHeader, Writer.Lines[0]);
    AssertEquals(' ', Writer.Lines[1]);
  finally
    Writer.Close;
    WriterInterface := nil;
    Writer := nil;
    Source := nil;
  end;
end;

procedure TTestAHW52Unit18ExportWorkflow.TestTextFileWriterWritesAndCloses;
var
  FileName: string;
  Writer: IUnit18TextWriter;
  Lines: TStringList;
begin
  FileName := GetTempFileName(GetTempDir, 'u18');
  Writer := TUnit18TextFileWriter.Create(FileName);
  try
    Writer.WriteLine(Unit18ExportHeader);
    Writer.WriteLine(' ');
    Writer.Close;

    Lines := TStringList.Create;
    try
      Lines.LoadFromFile(FileName);
      AssertEquals(2, Lines.Count);
      AssertEquals(Unit18ExportHeader, Lines[0]);
      AssertEquals(' ', Lines[1]);
    finally
      Lines.Free;
    end;
  finally
    Writer.Close;
    Writer := nil;
    if FileExists(FileName) and not DeleteFile(FileName) then
      raise Exception.Create('The synthetic export file could not be deleted.');
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit18ExportWorkflow);

end.
