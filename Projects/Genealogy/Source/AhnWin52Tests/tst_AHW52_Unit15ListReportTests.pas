unit tst_AHW52_Unit15ListReportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit15ListReport = class(TTestCase)
  published
    procedure TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
    procedure TestSyntheticRowsPrepareAndPreserveCallerDataset;
    procedure TestGlobalSearchProjectionMapsFieldsAndPreservesCursor;
    procedure TestGlobalSearchProjectionUsesSourceDisplayText;
    procedure TestGlobalSearchProjectionReportsMissingSourceField;
    procedure TestGlobalSearchProjectionRejectsInactiveSource;
    procedure TestGlobalSearchProjectionRejectsNilSource;
    procedure TestGlobalSearchProjectionRejectsNonBrowseSource;
    procedure TestGlobalSearchProjectionSupportsEmptySource;
    procedure TestVorlistProjectionMapsMemoAndDisplayText;
    procedure TestVorlistProjectionSupportsEmptySource;
    procedure TestVorlistProjectionRejectsMissingField;
    procedure TestSingleColumnProjectionMapsMemoAndPreservesCursor;
    procedure TestSingleColumnProjectionSupportsEmptySource;
    procedure TestSingleColumnProjectionRejectsMissingOrWrongTypeField;
    procedure TestSingleColumnProjectionRejectsNilInactiveAndNonBrowseSource;
    procedure TestSpitzbasProjectionMapsFieldsAndPreservesCursor;
    procedure TestSpitzbasProjectionSupportsEmptySourceAndRejectsBadSchema;
    procedure TestSpitzbasProjectionRejectsInvalidSourceStates;
    procedure TestTable22ProjectionMapsMemoAndDisplayText;
    procedure TestTable22ProjectionSupportsEmptySourceAndRejectsBadSchema;
    procedure TestTable22ProjectionRejectsInvalidSourceStates;
    procedure TestMissingDFMFieldIsReported;
    procedure TestUnit15FormCreatesOwnedLazReportBuilder;
    procedure TestPreparedPagesExposePdfPageContract;
    procedure TestUnit15ReportExportsPdfFromSyntheticRows;
  end;

implementation

uses
  SysUtils, Classes, DB, BufDataset, Forms, Graphics, LR_Class, Types,
  Unit15ListReport, Unit15GlobalSearchRows, Unit15VorlistRows,
  Unit15SingleColumnRows, Unit15SpitzbasRows,
  Unit15Table22Rows,
  SingleColumnA4ReportVariantForm, ReportPdfContracts, MormotPdfReportWriter;

type
  TDisplayTextOverride = class
    procedure GetText(Sender: TField; var AText: string;
      DisplayText: Boolean);
  end;

procedure TDisplayTextOverride.GetText(Sender: TField; var AText: string;
  DisplayText: Boolean);
begin
  if DisplayText then
    AText := 'Displayed: ' + Sender.AsString
  else
    AText := Sender.AsString;
end;

const
  GlobalSearchSourceFields: array[0..14] of string = (
    'Name', 'Nummer', 'Gebtag', 'Gebmonat', 'Gebjahr', 'Gebort',
    'Sttag', 'Stmonat', 'Stjahr', 'Stort', 'Htag', 'Hmonat', 'Hjahr',
    'Hort', 'Hname');
  GlobalSearchSourceFieldSizes: array[0..14] of Integer = (
    60, 0, 4, 3, 4, 30, 4, 3, 4, 30, 7, 3, 4, 30, 60);
  FirstGlobalSearchRowValues: array[0..14] of string = (
    'First Name', '101', '01', '02', '1901', 'First Birth', '03', '04',
    '1951', 'First Death', '05', '06', '1921', 'First Baptism',
    'First Godparent');

procedure AddGlobalSearchFieldDefs(ADataset: TBufDataset;
  AFieldCount: Integer);
var
  fieldIndex: Integer;
begin
  for fieldIndex := 0 to AFieldCount - 1 do
    if fieldIndex = 1 then
      ADataset.FieldDefs.Add(GlobalSearchSourceFields[fieldIndex], ftInteger)
    else
      ADataset.FieldDefs.Add(GlobalSearchSourceFields[fieldIndex], ftString,
        GlobalSearchSourceFieldSizes[fieldIndex]);
end;

function CreateSyntheticGlobalSearchRows: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticTable16';
  AddGlobalSearchFieldDefs(Result, Length(GlobalSearchSourceFields));
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['First Name', 101, '01', '02', '1901', 'First Birth',
    '03', '04', '1951', 'First Death', '05', '06', '1921', 'First Baptism',
    'First Godparent']);
  Result.AppendRecord(['Second Name', 202, '11', '12', '1902',
    'Second Birth', '13', '14', '1952', 'Second Death', '15', '16', '1922',
    'Second Baptism', 'Second Godparent']);
end;

function CreateSyntheticVorlistSource: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticTable14Vorlist';
  Result.FieldDefs.Add('Zeile', ftMemo);
  Result.FieldDefs.Add('Nm', ftString, 25);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['First ancestor line' + LineEnding + 'continued',
    'First name']);
  Result.AppendRecord(['Second ancestor line', 'Second name']);
end;

function CreateSyntheticSpitzbasSource: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticTable27Spitzbas';
  Result.FieldDefs.Add('Namvorn', ftString, 125);
  Result.FieldDefs.Add('Kn', ftString, 20);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['First given names', 'A1']);
  Result.AppendRecord(['Second given names', 'B2']);
end;

function CreateSyntheticTable22Source: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticTable22Register';
  Result.FieldDefs.Add('No', ftString, 50);
  Result.FieldDefs.Add('Zus', ftMemo);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['R1', 'First register entry' + LineEnding + 'continued']);
  Result.AppendRecord(['R2', 'Second register entry']);
end;

function CreateSyntheticRows: TBufDataset;
var
  fieldIndex: Integer;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticRows';
  for fieldIndex := 1 to 15 do
    Result.FieldDefs.Add(Format('QRDBText%d', [fieldIndex]), ftString, 40);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['Field 1', 'Field 2', 'Field 3', 'Field 4',
    'Field 5', 'Field 6', 'Field 7', 'Field 8', 'Field 9', 'Field 10',
    'Field 11', 'Field 12', 'Field 13', 'Field 14', 'Field 15']);
  Result.AppendRecord(['Other 1', 'Other 2', 'Other 3', 'Other 4',
    'Other 5', 'Other 6', 'Other 7', 'Other 8', 'Other 9', 'Other 10',
    'Other 11', 'Other 12', 'Other 13', 'Other 14', 'Other 15']);
end;

function NewTemporaryPdfName: string;
var
  fileId: TGUID;
begin
  if CreateGUID(fileId) <> 0 then
    raise Exception.Create('Could not create test output file name.');
  Result := IncludeTrailingPathDelimiter(GetTempDir) +
    'AhnWin52-Unit15-' + GUIDToString(fileId) + '.pdf';
end;

procedure AssertMemo(AReport: TfrReport; const AObjectName, AExpectedText: string);
var
  reportObject: TfrObject;
begin
  reportObject := AReport.Pages[0].FindObject(AObjectName);
  if not (reportObject is TfrMemoView) then
    raise Exception.CreateFmt('Template object "%s" is not a memo.',
      [AObjectName]);
  if Pos(AExpectedText, TfrMemoView(reportObject).Memo.Text) = 0 then
    raise Exception.CreateFmt('Template object "%s" lacks "%s".',
      [AObjectName, AExpectedText]);
end;

procedure TTestAHW52Unit15ListReport.
  TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  reportObject: TfrObject;
  fieldIndex: Integer;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  try
    AssertEquals(1, listReport.Report.Pages.Count);
    AssertEquals(1, listReport.TemplateColumnCount);
    AssertEquals('Unit15Rows', listReport.Report.Dataset.Name);
    AssertMemo(listReport.Report, 'Caption1', 'QRLabel1');
    AssertMemo(listReport.Report, 'Caption2', 'QRLabel2');
    AssertMemo(listReport.Report, 'QRDBText1', 'Unit15Rows."QRDBText1"');
    AssertMemo(listReport.Report, 'QRDBText2', 'Unit15Rows."QRDBText2"');
    AssertMemo(listReport.Report, 'QRDBText15', 'Unit15Rows."QRDBText15"');
    AssertMemo(listReport.Report, 'PrintedDate', '[DATE]');
    AssertMemo(listReport.Report, 'PageNumber', '[PAGE#]');
    AssertMemo(listReport.Report, 'QRMemo1', #13#10);
    for fieldIndex := 3 to 15 do
    begin
      reportObject := listReport.Report.Pages[0].FindObject(
        Format('QRDBText%d', [fieldIndex]));
      AssertNotNull(reportObject);
      AssertFalse(Format('DFM field QRDBText%d remains hidden.', [fieldIndex]),
        reportObject.Visible);
    end;
    AssertNull(listReport.Report.Pages[0].FindObject('QRImage4'));
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSyntheticRowsPrepareAndPreserveCallerDataset;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  currentEntry: string;
begin
  dataSet := CreateSyntheticRows;
  listReport := nil;
  try
    dataSet.Last;
    currentEntry := dataSet.FieldByName('QRDBText1').AsString;
    listReport := TUnit15ListReport.Create(nil, dataSet);
    AssertTrue('The report should prepare its two synthetic rows.',
      listReport.PrepareReport);
    AssertTrue('Preparation should produce at least one report page.',
      listReport.PreparedPageCount > 0);
    AssertTrue('The caller retains ownership of the dataset.', dataSet.Active);
    AssertEquals(currentEntry, dataSet.FieldByName('QRDBText1').AsString);
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionMapsFieldsAndPreservesCursor;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  listReport: TUnit15ListReport;
  fieldIndex: Integer;
begin
  sourceDataSet := CreateSyntheticGlobalSearchRows;
  projectedDataSet := nil;
  listReport := nil;
  try
    sourceDataSet.Last;
    projectedDataSet := CreateUnit15GlobalSearchRows(sourceDataSet);

    AssertTrue('The source dataset remains active.', sourceDataSet.Active);
    AssertEquals('Projection preserves the caller cursor.', 202,
      sourceDataSet.FieldByName('Nummer').AsInteger);
    AssertEquals('The projection has all report fields.', 15,
      projectedDataSet.FieldCount);
    AssertEquals(2, projectedDataSet.RecordCount);
    projectedDataSet.First;
    for fieldIndex := Low(FirstGlobalSearchRowValues) to
      High(FirstGlobalSearchRowValues) do
      AssertEquals(
        Format('The first row maps Table16 field %s.',
          [GlobalSearchSourceFields[fieldIndex]]),
        FirstGlobalSearchRowValues[fieldIndex],
        projectedDataSet.FieldByName(Format('QRDBText%d',
          [fieldIndex + 1])).AsString);
    projectedDataSet.Next;
    AssertEquals('202', projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('Second Godparent',
      projectedDataSet.FieldByName('QRDBText15').AsString);

    listReport := TUnit15ListReport.Create(nil, projectedDataSet);
    AssertTrue(
      'The projected Table16 rows satisfy the recovered Unit15 layout.',
      listReport.PrepareReport);
  finally
    listReport.Free;
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionUsesSourceDisplayText;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  numberField: TField;
begin
  sourceDataSet := CreateSyntheticGlobalSearchRows;
  projectedDataSet := nil;
  try
    numberField := sourceDataSet.FieldByName('Nummer');
    TNumericField(numberField).DisplayFormat := '00000';
    sourceDataSet.First;

    AssertEquals('The fixture distinguishes DisplayText from AsString.',
      '00101', numberField.DisplayText);
    AssertEquals('The underlying integer string is unformatted.',
      '101', numberField.AsString);

    projectedDataSet := CreateUnit15GlobalSearchRows(sourceDataSet);
    AssertEquals('QRDBText2 preserves the source field display text.',
      numberField.DisplayText,
      projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('Projection preserves the source cursor.', 101,
      numberField.AsInteger);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestVorlistProjectionMapsMemoAndDisplayText;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  listReport: TUnit15ListReport;
  textOverride: TDisplayTextOverride;
  nmField: TField;
begin
  sourceDataSet := CreateSyntheticVorlistSource;
  projectedDataSet := nil;
  listReport := nil;
  textOverride := TDisplayTextOverride.Create;
  try
    nmField := sourceDataSet.FieldByName('Nm');
    nmField.OnGetText := @textOverride.GetText;
    sourceDataSet.Last;

    projectedDataSet := CreateUnit15VorlistRows(sourceDataSet);

    AssertEquals('The projection retains both rows.', 2,
      projectedDataSet.RecordCount);
    AssertEquals('The source bookmark is restored.', 'Second name',
      nmField.AsString);
    AssertEquals('The memo field remains unbounded memo data.', Ord(ftMemo),
      Ord(projectedDataSet.FieldByName('QRDBText1').DataType));
    AssertEquals('The first memo value preserves its line break.',
      'First ancestor line' + LineEnding + 'continued',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    AssertEquals('The string field uses the source display text.',
      'Displayed: First name',
      projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('The remaining report fields are blank placeholders.', '',
      projectedDataSet.FieldByName('QRDBText15').AsString);

    listReport := TUnit15ListReport.Create(nil, projectedDataSet);
    AssertTrue('The Vorlist projection satisfies the recovered report layout.',
      listReport.PrepareReport);
  finally
    listReport.Free;
    projectedDataSet.Free;
    textOverride.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestVorlistProjectionSupportsEmptySource;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EmptySyntheticTable14';
  sourceDataSet.FieldDefs.Add('Zeile', ftMemo);
  sourceDataSet.FieldDefs.Add('Nm', ftString, 25);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  projectedDataSet := nil;
  try
    projectedDataSet := CreateUnit15VorlistRows(sourceDataSet);
    AssertEquals('An empty input produces an empty report dataset.', 0,
      projectedDataSet.RecordCount);
    AssertEquals('The empty projection retains all report fields.', 15,
      projectedDataSet.FieldCount);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestVorlistProjectionRejectsMissingField;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'IncompleteTable14';
  sourceDataSet.FieldDefs.Add('Zeile', ftMemo);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15VorlistRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('Nm', E.Message) > 0;
    end;
    AssertTrue('The projection rejects a missing Nm field.', rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSingleColumnProjectionMapsMemoAndPreservesCursor;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  listReport: TUnit15ListReport;
begin
  sourceDataSet := CreateSyntheticVorlistSource;
  sourceDataSet.Last;
  projectedDataSet := nil;
  listReport := nil;
  try
    projectedDataSet := CreateUnit15SingleColumnRows(sourceDataSet);

    AssertEquals('The projection retains both source rows.', 2,
      projectedDataSet.RecordCount);
    AssertEquals('The source cursor remains on the second row.',
      'Second ancestor line', sourceDataSet.FieldByName('Zeile').AsString);
    AssertEquals('The first report value remains memo text.', Ord(ftMemo),
      Ord(projectedDataSet.FieldByName('QRDBText1').DataType));
    AssertEquals('The first memo value is copied unchanged.',
      'First ancestor line' + LineEnding + 'continued',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    AssertEquals('Unused report fields are blank.', '',
      projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('The final unused report field is blank.', '',
      projectedDataSet.FieldByName('QRDBText15').AsString);

    projectedDataSet.Next;
    AssertEquals('Rows retain source order.', 'Second ancestor line',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    listReport := TUnit15ListReport.Create(nil, projectedDataSet);
    AssertTrue('The single-column projection satisfies the report layout.',
      listReport.PrepareReport);
  finally
    listReport.Free;
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSingleColumnProjectionSupportsEmptySource;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EmptySyntheticTable14SingleColumn';
  sourceDataSet.FieldDefs.Add('Zeile', ftMemo);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  projectedDataSet := nil;
  try
    projectedDataSet := CreateUnit15SingleColumnRows(sourceDataSet);
    AssertEquals('An empty source creates no report rows.', 0,
      projectedDataSet.RecordCount);
    AssertEquals('The report field contract is retained.', 15,
      projectedDataSet.FieldCount);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSingleColumnProjectionRejectsMissingOrWrongTypeField;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'MissingZeileTable14';
  sourceDataSet.FieldDefs.Add('Nm', ftString, 25);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15SingleColumnRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('Zeile', E.Message) > 0;
    end;
    AssertTrue('The projection rejects a missing Zeile field.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'WrongTypeZeileTable14';
  sourceDataSet.FieldDefs.Add('Zeile', ftString, 255);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15SingleColumnRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('memo field', E.Message) > 0;
    end;
    AssertTrue('The projection rejects a non-memo Zeile field.', rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSingleColumnProjectionRejectsNilInactiveAndNonBrowseSource;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  rejected := False;
  try
    CreateUnit15SingleColumnRows(nil).Free;
  except
    on E: EArgumentNilException do
      rejected := E.Message = 'ASource';
  end;
  AssertTrue('The projection reports a nil source.', rejected);

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'InactiveTable14SingleColumn';
  sourceDataSet.FieldDefs.Add('Zeile', ftMemo);
  try
    rejected := False;
    try
      CreateUnit15SingleColumnRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('active dataset', E.Message) > 0;
    end;
    AssertTrue('The projection rejects an inactive source.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EditingTable14SingleColumn';
  sourceDataSet.FieldDefs.Add('Zeile', ftMemo);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  sourceDataSet.Append;
  try
    rejected := False;
    try
      CreateUnit15SingleColumnRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('browse state', E.Message) > 0;
    end;
    AssertTrue('The projection rejects a pending edit.', rejected);
  finally
    sourceDataSet.Cancel;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSpitzbasProjectionMapsFieldsAndPreservesCursor;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  textOverride: TDisplayTextOverride;
  listReport: TUnit15ListReport;
begin
  sourceDataSet := CreateSyntheticSpitzbasSource;
  projectedDataSet := nil;
  textOverride := TDisplayTextOverride.Create;
  listReport := nil;
  try
    sourceDataSet.FieldByName('Namvorn').OnGetText := @textOverride.GetText;
    sourceDataSet.Last;
    projectedDataSet := CreateUnit15SpitzbasRows(sourceDataSet);

    AssertEquals('Both source rows are copied.', 2,
      projectedDataSet.RecordCount);
    AssertEquals('The source cursor is restored to the second row.',
      'Second given names', sourceDataSet.FieldByName('Namvorn').AsString);
    AssertEquals('QRDBText1 uses Namvorn display text.',
      'Displayed: First given names',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    AssertEquals('QRDBText2 maps Kn.', 'A1',
      projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('Fields not assigned by the caller stay blank.', '',
      projectedDataSet.FieldByName('QRDBText15').AsString);

    projectedDataSet.Next;
    AssertEquals('The source row order is retained.',
      'Displayed: Second given names',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    AssertEquals('The second Kn value is retained.', 'B2',
      projectedDataSet.FieldByName('QRDBText2').AsString);

    listReport := TUnit15ListReport.Create(nil, projectedDataSet);
    AssertTrue('The projected rows prepare the Unit15 report.',
      listReport.PrepareReport);
  finally
    listReport.Free;
    projectedDataSet.Free;
    textOverride.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSpitzbasProjectionSupportsEmptySourceAndRejectsBadSchema;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EmptySyntheticTable27Spitzbas';
  sourceDataSet.FieldDefs.Add('Namvorn', ftString, 125);
  sourceDataSet.FieldDefs.Add('Kn', ftString, 20);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  projectedDataSet := nil;
  try
    projectedDataSet := CreateUnit15SpitzbasRows(sourceDataSet);
    AssertEquals('An empty source creates no output rows.', 0,
      projectedDataSet.RecordCount);
    AssertEquals('The empty output still has the report schema.', 15,
      projectedDataSet.FieldCount);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'IncompleteSyntheticTable27Spitzbas';
  sourceDataSet.FieldDefs.Add('Namvorn', ftString, 125);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15SpitzbasRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('Kn', E.Message) > 0;
    end;
    AssertTrue('A missing Kn field is reported.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'WrongTypeSyntheticTable27Spitzbas';
  sourceDataSet.FieldDefs.Add('Namvorn', ftInteger);
  sourceDataSet.FieldDefs.Add('Kn', ftString, 20);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15SpitzbasRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('Namvorn', E.Message) > 0;
    end;
    AssertTrue('A non-string Namvorn field is rejected.', rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSpitzbasProjectionRejectsInvalidSourceStates;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  rejected := False;
  try
    CreateUnit15SpitzbasRows(nil).Free;
  except
    on E: EArgumentNilException do
      rejected := E.Message = 'ASource';
  end;
  AssertTrue('A nil source is rejected explicitly.', rejected);

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'InactiveSyntheticTable27Spitzbas';
  sourceDataSet.FieldDefs.Add('Namvorn', ftString, 125);
  sourceDataSet.FieldDefs.Add('Kn', ftString, 20);
  try
    rejected := False;
    try
      CreateUnit15SpitzbasRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('active dataset', E.Message) > 0;
    end;
    AssertTrue('An inactive source is rejected explicitly.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := CreateSyntheticSpitzbasSource;
  sourceDataSet.Append;
  try
    rejected := False;
    try
      CreateUnit15SpitzbasRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('browse state', E.Message) > 0;
    end;
    AssertTrue('A source with a pending edit is rejected.', rejected);
  finally
    sourceDataSet.Cancel;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestTable22ProjectionMapsMemoAndDisplayText;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  textOverride: TDisplayTextOverride;
  listReport: TUnit15ListReport;
begin
  sourceDataSet := CreateSyntheticTable22Source;
  sourceDataSet.Last;
  projectedDataSet := nil;
  textOverride := TDisplayTextOverride.Create;
  listReport := nil;
  try
    sourceDataSet.FieldByName('No').OnGetText := @textOverride.GetText;
    projectedDataSet := CreateUnit15Table22Rows(sourceDataSet);

    AssertEquals('The projection retains both source rows.', 2,
      projectedDataSet.RecordCount);
    AssertEquals('The original cursor is restored to the second row.', 'R2',
      sourceDataSet.FieldByName('No').AsString);
    AssertEquals('The memo field is retained as memo data.', Ord(ftMemo),
      Ord(projectedDataSet.FieldByName('QRDBText1').DataType));
    AssertEquals('The first memo value preserves its line break.',
      'First register entry' + LineEnding + 'continued',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    AssertEquals('The No field uses its source display text.',
      'Displayed: R1', projectedDataSet.FieldByName('QRDBText2').AsString);
    AssertEquals('Unused report fields stay blank.', '',
      projectedDataSet.FieldByName('QRDBText15').AsString);

    projectedDataSet.Next;
    AssertEquals('The second memo remains in source order.',
      'Second register entry',
      projectedDataSet.FieldByName('QRDBText1').AsString);
    listReport := TUnit15ListReport.Create(nil, projectedDataSet);
    AssertTrue('The projection satisfies the Unit15 report layout.',
      listReport.PrepareReport);
  finally
    listReport.Free;
    projectedDataSet.Free;
    textOverride.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestTable22ProjectionSupportsEmptySourceAndRejectsBadSchema;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EmptySyntheticTable22';
  sourceDataSet.FieldDefs.Add('No', ftString, 50);
  sourceDataSet.FieldDefs.Add('Zus', ftMemo);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  projectedDataSet := nil;
  try
    projectedDataSet := CreateUnit15Table22Rows(sourceDataSet);
    AssertEquals('An empty source produces no rows.', 0,
      projectedDataSet.RecordCount);
    AssertEquals('An empty projection keeps the report field count.', 15,
      projectedDataSet.FieldCount);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'IncompleteSyntheticTable22';
  sourceDataSet.FieldDefs.Add('No', ftString, 50);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15Table22Rows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('Zus', E.Message) > 0;
    end;
    AssertTrue('A missing Zus field is rejected.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'WrongTypeSyntheticTable22';
  sourceDataSet.FieldDefs.Add('No', ftString, 50);
  sourceDataSet.FieldDefs.Add('Zus', ftString, 100);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15Table22Rows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('memo field', E.Message) > 0;
    end;
    AssertTrue('A non-memo Zus field is rejected.', rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestTable22ProjectionRejectsInvalidSourceStates;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  rejected := False;
  try
    CreateUnit15Table22Rows(nil).Free;
  except
    on E: EArgumentNilException do
      rejected := E.Message = 'ASource';
  end;
  AssertTrue('A nil source is rejected explicitly.', rejected);

  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'InactiveSyntheticTable22';
  sourceDataSet.FieldDefs.Add('No', ftString, 50);
  sourceDataSet.FieldDefs.Add('Zus', ftMemo);
  try
    rejected := False;
    try
      CreateUnit15Table22Rows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('active dataset', E.Message) > 0;
    end;
    AssertTrue('An inactive source is rejected explicitly.', rejected);
  finally
    sourceDataSet.Free;
  end;

  sourceDataSet := CreateSyntheticTable22Source;
  sourceDataSet.Append;
  try
    rejected := False;
    try
      CreateUnit15Table22Rows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('browse state', E.Message) > 0;
    end;
    AssertTrue('A pending edit is rejected explicitly.', rejected);
  finally
    sourceDataSet.Cancel;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionReportsMissingSourceField;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'IncompleteTable16';
  AddGlobalSearchFieldDefs(sourceDataSet,
    Length(GlobalSearchSourceFields) - 1);
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  try
    rejected := False;
    try
      CreateUnit15GlobalSearchRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
      begin
        rejected := True;
        AssertTrue('The missing field is named in the error.',
          Pos('Hname', E.Message) > 0);
      end;
    end;
    AssertTrue('The projection rejects an incomplete Table16 schema.',
      rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionRejectsInactiveSource;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'InactiveTable16';
  AddGlobalSearchFieldDefs(sourceDataSet, Length(GlobalSearchSourceFields));
  try
    rejected := False;
    try
      CreateUnit15GlobalSearchRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('active dataset', E.Message) > 0;
    end;
    AssertTrue('The projection rejects an inactive Table16 dataset.',
      rejected);
  finally
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionRejectsNilSource;
var
  rejected: Boolean;
begin
  rejected := False;
  try
    CreateUnit15GlobalSearchRows(nil).Free;
  except
    on E: EArgumentNilException do
      rejected := E.Message = 'ASource';
  end;
  AssertTrue('The projection reports a nil source argument.', rejected);
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionRejectsNonBrowseSource;
var
  sourceDataSet: TBufDataset;
  rejected: Boolean;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EditingTable16';
  AddGlobalSearchFieldDefs(sourceDataSet, Length(GlobalSearchSourceFields));
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  sourceDataSet.Append;
  try
    rejected := False;
    try
      CreateUnit15GlobalSearchRows(sourceDataSet).Free;
    except
      on E: EDatabaseError do
        rejected := Pos('browse state', E.Message) > 0;
    end;
    AssertTrue(
      'The projection rejects a Table16 dataset with pending edits.',
      rejected);
  finally
    sourceDataSet.Cancel;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestGlobalSearchProjectionSupportsEmptySource;
var
  sourceDataSet: TBufDataset;
  projectedDataSet: TBufDataset;
begin
  sourceDataSet := TBufDataset.Create(nil);
  sourceDataSet.Name := 'EmptyTable16';
  AddGlobalSearchFieldDefs(sourceDataSet, Length(GlobalSearchSourceFields));
  sourceDataSet.CreateDataset;
  sourceDataSet.Open;
  projectedDataSet := nil;
  try
    projectedDataSet := CreateUnit15GlobalSearchRows(sourceDataSet);
    AssertTrue('The source remains active when it is empty.',
      sourceDataSet.Active);
    AssertEquals(15, projectedDataSet.FieldCount);
    AssertEquals(0, projectedDataSet.RecordCount);
  finally
    projectedDataSet.Free;
    sourceDataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestMissingDFMFieldIsReported;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  rejected: Boolean;
begin
  dataSet := TBufDataset.Create(nil);
  dataSet.Name := 'SyntheticRows';
  dataSet.FieldDefs.Add('QRDBText1', ftString, 40);
  dataSet.CreateDataset;
  dataSet.Open;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  try
    rejected := False;
    try
      listReport.PrepareReport;
    except
      on E: EDatabaseError do
      begin
        rejected := True;
        AssertTrue('The missing DFM field should be identified.',
          Pos('QRDBText2', E.Message) > 0);
      end;
    end;
    AssertTrue('A missing report field must not return false success.',
      rejected);
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestUnit15FormCreatesOwnedLazReportBuilder;
var
  dataSet: TBufDataset;
  reportForm: TSingleColumnA4ReportVariantForm;
  listReport: TUnit15ListReport;
begin
  dataSet := CreateSyntheticRows;
  reportForm := TSingleColumnA4ReportVariantForm.Create(nil);
  try
    AssertEquals('Form15', reportForm.Caption);
    AssertEquals(0, reportForm.ComponentCount);
    listReport := reportForm.CreateUnit15ListReport(dataSet);
    AssertTrue('The Unit15 form should own its LazReport builder.',
      listReport.Owner = reportForm);
    AssertTrue(listReport.PrepareReport);
  finally
    reportForm.Free;
    AssertTrue('The form must not destroy the caller dataset.', dataSet.Active);
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestPreparedPagesExposePdfPageContract;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  pageSource: IReportPageSource;
  pageDefinition: TReportPageDefinition;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  pageSource := listReport;
  try
    AssertTrue(listReport.PrepareReport);
    AssertTrue('The prepared report should expose at least one page.',
      pageSource.GetPageCount > 0);
    pageDefinition := pageSource.GetPageDefinition(0);
    AssertEquals(595, pageDefinition.WidthPoints);
    AssertEquals(842, pageDefinition.HeightPoints);
    AssertEquals(Ord(rpoPortrait), Ord(pageDefinition.Orientation));
  finally
    pageSource := nil;
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestUnit15ReportExportsPdfFromSyntheticRows;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  pdfStream: TFileStream;
  pdfContent: AnsiString;
begin
  dataSet := CreateSyntheticRows;
  dataSet.Last;
  listReport := nil;
  writer := TMormotPdfReportWriter.Create;
  outputFileName := NewTemporaryPdfName;
  try
    metadata.Title := 'Synthetic Unit15 list report';
    metadata.Author := 'AhnWin52 tests';
    metadata.Subject := 'Recovered Unit15 layout';
    metadata.Keywords := 'synthetic; Unit15';
    metadata.Creator := 'AhnWin52 test suite';
    listReport := TUnit15ListReport.Create(nil, dataSet);
    listReport.ExportToPdf(metadata, outputFileName, writer);

    AssertTrue('The Unit15 PDF should be created.', FileExists(outputFileName));
    pdfStream := TFileStream.Create(outputFileName,
      fmOpenRead or fmShareDenyNone);
    try
      AssertTrue('The Unit15 PDF should contain data.', pdfStream.Size > 0);
      SetLength(pdfContent, pdfStream.Size);
      pdfStream.ReadBuffer(pdfContent[1], Length(pdfContent));
    finally
      pdfStream.Free;
    end;
    AssertEquals('%PDF-', Copy(string(pdfContent), 1, 5));
    AssertTrue('The Unit15 PDF should contain its requested title.',
      Pos('Synthetic Unit15 list report', string(pdfContent)) > 0);
    AssertTrue('The Unit15 PDF should use recovered A4 page dimensions.',
      Pos('0 0 595 842', string(pdfContent)) > 0);
    AssertTrue('The caller dataset should remain active.', dataSet.Active);
    AssertEquals('Other 1', dataSet.FieldByName('QRDBText1').AsString);
  finally
    listReport.Free;
    writer := nil;
    dataSet.Free;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit15ListReport);

end.
