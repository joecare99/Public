unit tst_AHW52_IndexedLookupProviderTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52IndexedLookupProvider = class(TTestCase)
  published
    procedure TestCaseLookupHitByNamedIndex;
    procedure TestCaseLookupUsesOrderedCompositeKey;
    procedure TestCaseLookupMissPreservesCursor;
    procedure TestCaseLookupHitPreservesCursor;
    procedure TestCaseDuplicateKeyReturnsFirstInsertedRow;
    procedure TestCaseUnknownIndexRaises;
    procedure TestCaseWrongKeyCountRaises;
    procedure TestCaseProviderFailurePropagates;
  end;

implementation

uses
  Classes, SysUtils, IndexedLookupContract;

type
  EInjectedLookupFailure = class(Exception);

  TSyntheticLookupRow = class
  public
    RecordId: Integer;
    Fields: TStringList;
    constructor Create(const ARecordId: Integer);
    destructor Destroy; override;
  end;

  TSyntheticIndexedLookupProvider = class(TInterfacedObject,
    IIndexedLookupProvider)
  private
    FIndexes: TStringList;
    FRows: TList;
    FCurrentRecordId: Integer;
    FFailLookup: Boolean;
    function GetCurrentRecordId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddIndex(const IndexName: string; const KeyFields: array of string);
    procedure AddRow(const RecordId: Integer; const FieldNames,
      FieldValues: TStrings);
    function Lookup(const IndexName: string; const KeyValues: TStrings):
      TIndexedLookupResult;
    procedure SelectCurrentRecord(const RecordId: Integer);
    property FailLookup: Boolean read FFailLookup write FFailLookup;
  end;

constructor TSyntheticLookupRow.Create(const ARecordId: Integer);
begin
  inherited Create;
  RecordId := ARecordId;
  Fields := TStringList.Create;
end;

destructor TSyntheticLookupRow.Destroy;
begin
  Fields.Free;
  inherited Destroy;
end;

constructor TSyntheticIndexedLookupProvider.Create;
begin
  inherited Create;
  FIndexes := TStringList.Create;
  FRows := TList.Create;
end;

destructor TSyntheticIndexedLookupProvider.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to FIndexes.Count - 1 do
    FIndexes.Objects[Index].Free;
  FIndexes.Free;

  for Index := 0 to FRows.Count - 1 do
    TSyntheticLookupRow(FRows[Index]).Free;
  FRows.Free;
  inherited Destroy;
end;

procedure TSyntheticIndexedLookupProvider.AddIndex(const IndexName: string;
  const KeyFields: array of string);
var
  Fields: TStringList;
  Index: Integer;
begin
  if FIndexes.IndexOf(IndexName) >= 0 then
    raise EArgumentException.CreateFmt('Index "%s" is already defined.',
      [IndexName]);
  if Length(KeyFields) = 0 then
    raise EArgumentException.Create('An index must define at least one key field.');

  Fields := TStringList.Create;
  try
    for Index := 0 to High(KeyFields) do
      Fields.Add(KeyFields[Index]);
    FIndexes.AddObject(IndexName, Fields);
    Fields := nil;
  finally
    Fields.Free;
  end;
end;

procedure TSyntheticIndexedLookupProvider.AddRow(const RecordId: Integer;
  const FieldNames, FieldValues: TStrings);
var
  Row: TSyntheticLookupRow;
  Index: Integer;
begin
  if (FieldNames = nil) or (FieldValues = nil) then
    raise EArgumentNilException.Create('FieldNames/FieldValues');
  if FieldNames.Count <> FieldValues.Count then
    raise EArgumentException.Create('Field names and values must have equal counts.');

  Row := TSyntheticLookupRow.Create(RecordId);
  try
    for Index := 0 to FieldNames.Count - 1 do
      Row.Fields.Values[FieldNames[Index]] := FieldValues[Index];
    FRows.Add(Row);
    Row := nil;
  finally
    Row.Free;
  end;
end;

function TSyntheticIndexedLookupProvider.Lookup(const IndexName: string;
  const KeyValues: TStrings): TIndexedLookupResult;
var
  IndexPosition: Integer;
  IndexFields: TStringList;
  Row: TSyntheticLookupRow;
  RowIndex: Integer;
  KeyIndex: Integer;
  Matches: Boolean;
begin
  if KeyValues = nil then
    raise EArgumentNilException.Create('KeyValues');
  if FFailLookup then
    raise EInjectedLookupFailure.Create('Injected synthetic provider failure.');

  IndexPosition := FIndexes.IndexOf(IndexName);
  if IndexPosition < 0 then
    raise EUnknownLookupIndex.CreateFmt('Unknown lookup index "%s".',
      [IndexName]);

  IndexFields := TStringList(FIndexes.Objects[IndexPosition]);
  if KeyValues.Count <> IndexFields.Count then
    raise EInvalidLookupKey.CreateFmt(
      'Index "%s" expects %d key values, received %d.',
      [IndexName, IndexFields.Count, KeyValues.Count]);

  Result.Found := False;
  Result.RecordId := 0;
  for RowIndex := 0 to FRows.Count - 1 do
  begin
    Row := TSyntheticLookupRow(FRows[RowIndex]);
    Matches := True;
    for KeyIndex := 0 to IndexFields.Count - 1 do
      if Row.Fields.Values[IndexFields[KeyIndex]] <> KeyValues[KeyIndex] then
      begin
        Matches := False;
        Break;
      end;

    if Matches then
    begin
      Result.Found := True;
      Result.RecordId := Row.RecordId;
      Exit;
    end;
  end;
end;

function TSyntheticIndexedLookupProvider.GetCurrentRecordId: Integer;
begin
  Result := FCurrentRecordId;
end;

procedure TSyntheticIndexedLookupProvider.SelectCurrentRecord(
  const RecordId: Integer);
begin
  FCurrentRecordId := RecordId;
end;

function CreateLookupProvider: TSyntheticIndexedLookupProvider;
var
  FieldNames: TStringList;
  FieldValues: TStringList;
begin
  Result := TSyntheticIndexedLookupProvider.Create;
  try
    { These names and key layouts are test fixtures, not recovered BDE metadata. }
    Result.AddIndex('namgeb', ['SyntheticKeyA', 'SyntheticKeyB']);
    Result.AddIndex('geba', ['SyntheticKeyC', 'SyntheticKeyD']);

    FieldNames := TStringList.Create;
    FieldValues := TStringList.Create;
    try
      FieldNames.Add('SyntheticKeyA');
      FieldNames.Add('SyntheticKeyB');
      FieldNames.Add('SyntheticKeyC');
      FieldNames.Add('SyntheticKeyD');

      FieldValues.Add('alpha');
      FieldValues.Add('one');
      FieldValues.Add('birth-x');
      FieldValues.Add('suffix-x');
      Result.AddRow(1, FieldNames, FieldValues);

      FieldValues[0] := 'beta';
      FieldValues[1] := 'two';
      FieldValues[2] := 'birth-y';
      FieldValues[3] := 'suffix-y';
      Result.AddRow(2, FieldNames, FieldValues);

      FieldValues[0] := 'alpha';
      FieldValues[1] := 'one';
      FieldValues[2] := 'birth-z';
      FieldValues[3] := 'suffix-z';
      Result.AddRow(3, FieldNames, FieldValues);
    finally
      FieldValues.Free;
      FieldNames.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function CreateKeyValues(const Values: array of string): TStringList;
var
  Index: Integer;
begin
  Result := TStringList.Create;
  for Index := 0 to High(Values) do
    Result.Add(Values[Index]);
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseLookupHitByNamedIndex;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := CreateLookupProvider;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['birth-y', 'suffix-y']);
  try
    LookupResult := Provider.Lookup('geba', KeyValues);
    AssertTrue('The synthetic index should find a row.', LookupResult.Found);
    AssertEquals('The synthetic row ID should be returned.', 2,
      LookupResult.RecordId);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseLookupUsesOrderedCompositeKey;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := CreateLookupProvider;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['alpha', 'one']);
  try
    LookupResult := Provider.Lookup('namgeb', KeyValues);
    AssertTrue('The ordered composite key should match.', LookupResult.Found);
    AssertEquals('The first matching synthetic row should be returned.', 1,
      LookupResult.RecordId);

    KeyValues[0] := 'one';
    KeyValues[1] := 'alpha';
    LookupResult := Provider.Lookup('namgeb', KeyValues);
    AssertFalse('Reversing the composite values should not match.',
      LookupResult.Found);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseLookupMissPreservesCursor;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := CreateLookupProvider;
  ProviderObject.SelectCurrentRecord(2);
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['missing', 'suffix']);
  try
    LookupResult := Provider.Lookup('geba', KeyValues);
    AssertFalse('A missing key should be a normal miss.', LookupResult.Found);
    AssertEquals('A miss has no returned row ID.', 0, LookupResult.RecordId);
    AssertEquals('A miss must preserve the current record cursor.', 2,
      Provider.CurrentRecordId);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseLookupHitPreservesCursor;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := CreateLookupProvider;
  ProviderObject.SelectCurrentRecord(3);
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['birth-y', 'suffix-y']);
  try
    LookupResult := Provider.Lookup('geba', KeyValues);
    AssertTrue('A matching key should be found.', LookupResult.Found);
    AssertEquals('The match result should identify its row.', 2,
      LookupResult.RecordId);
    AssertEquals('A hit must preserve the current record cursor.', 3,
      Provider.CurrentRecordId);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseDuplicateKeyReturnsFirstInsertedRow;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := CreateLookupProvider;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['alpha', 'one']);
  try
    LookupResult := Provider.Lookup('namgeb', KeyValues);
    AssertTrue('Duplicate keys should still produce a match.',
      LookupResult.Found);
    AssertEquals('Duplicates should resolve by insertion order.', 1,
      LookupResult.RecordId);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseUnknownIndexRaises;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  Raised: Boolean;
begin
  ProviderObject := CreateLookupProvider;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['value']);
  try
    Raised := False;
    try
      Provider.Lookup('unknown-index', KeyValues);
    except
      on E: EUnknownLookupIndex do
        Raised := True;
    end;
    AssertTrue('An unknown index must raise a named error.', Raised);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseWrongKeyCountRaises;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  Raised: Boolean;
begin
  ProviderObject := CreateLookupProvider;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['alpha']);
  try
    Raised := False;
    try
      Provider.Lookup('namgeb', KeyValues);
    except
      on E: EInvalidLookupKey do
        Raised := True;
    end;
    AssertTrue('A composite key with the wrong arity must raise an error.',
      Raised);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestCaseProviderFailurePropagates;
var
  ProviderObject: TSyntheticIndexedLookupProvider;
  Provider: IIndexedLookupProvider;
  KeyValues: TStringList;
  Raised: Boolean;
begin
  ProviderObject := CreateLookupProvider;
  ProviderObject.FailLookup := True;
  Provider := ProviderObject;
  KeyValues := CreateKeyValues(['birth-y', 'suffix-y']);
  try
    Raised := False;
    try
      Provider.Lookup('geba', KeyValues);
    except
      on E: EInjectedLookupFailure do
        Raised := True;
    end;
    AssertTrue('Provider errors must not be converted into lookup misses.',
      Raised);
  finally
    KeyValues.Free;
    Provider := nil;
  end;
end;

initialization
  RegisterTest(TTestAHW52IndexedLookupProvider);

end.
