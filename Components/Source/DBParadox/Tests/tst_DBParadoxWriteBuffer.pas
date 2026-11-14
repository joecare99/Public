unit tst_DBParadoxWriteBuffer;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxWriteBuffer = class(TTestCase)
  published
    procedure StagedChangesAreVisibleAndRollbackDiscardsThem;
    procedure ImagesAreCopiedAcrossTheBufferBoundary;
    procedure SuccessfulCommitAppliesChanges;
    procedure FailedCommitCompensatesAppliedChangesInReverse;
    procedure FailedCompensationPoisonsTheBuffer;
  end;

implementation

uses
  Classes, SysUtils, DBParadoxWriteBuffer;

type
  TFakeWriteTarget = class(TInterfacedObject, IDBParadoxWriteTarget)
  private
    FRows: TStringList;
    FApplyCount: Integer;
    FFailApplyAt: Integer;
    FFailCompensation: Boolean;
    FCompensationOrder: TStringList;
    function KeyFor(const Change: TDBParadoxWriteChange): string;
    function ContainsRow(const Key: string): Boolean;
    function GetRow(const Key: string): string;
    procedure SetRow(const Key, Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ValidateChanges(const Changes: TDBParadoxWriteChanges);
    function ApplyChange(const Change: TDBParadoxWriteChange): TBytes;
    procedure CompensateChange(const Change: TDBParadoxWriteChange;
      const UndoToken: TBytes);
    procedure Seed(const TableName: string; RowID: Int64; const Value: string);
    function RowValue(const TableName: string; RowID: Int64): string;
    property ApplyCount: Integer read FApplyCount;
    property FailApplyAt: Integer read FFailApplyAt write FFailApplyAt;
    property FailCompensation: Boolean read FFailCompensation
      write FFailCompensation;
    property CompensationOrder: TStringList read FCompensationOrder;
  end;

function Bytes(const Value: string): TBytes;
begin
  Result := nil;
  SetLength(Result, Length(Value));
  if Length(Value) > 0 then
    Move(Value[1], Result[0], Length(Value));
end;

function StringOfBytes(const Value: TBytes): string;
begin
  Result := '';
  SetLength(Result, Length(Value));
  if Length(Value) > 0 then
    Move(Value[0], Result[1], Length(Value));
end;

constructor TFakeWriteTarget.Create;
begin
  inherited Create;
  FRows := TStringList.Create;
  FRows.NameValueSeparator := '=';
  FRows.Sorted := True;
  FRows.Duplicates := dupError;
  FCompensationOrder := TStringList.Create;
end;

destructor TFakeWriteTarget.Destroy;
begin
  FCompensationOrder.Free;
  FRows.Free;
  inherited Destroy;
end;

function TFakeWriteTarget.KeyFor(
  const Change: TDBParadoxWriteChange): string;
begin
  Result := LowerCase(Change.TableName) + '#' + IntToStr(Change.RowID);
end;

function TFakeWriteTarget.ContainsRow(const Key: string): Boolean;
begin
  Result := FRows.IndexOfName(Key) >= 0;
end;

function TFakeWriteTarget.GetRow(const Key: string): string;
var
  Index: Integer;
begin
  Index := FRows.IndexOfName(Key);
  if Index < 0 then
    Exit('');
  Result := FRows.ValueFromIndex[Index];
end;

procedure TFakeWriteTarget.SetRow(const Key, Value: string);
var
  Index: Integer;
begin
  Index := FRows.IndexOfName(Key);
  if Index >= 0 then
    FRows.Delete(Index);
  if Value <> #1 then
    FRows.Add(Key + '=' + Value);
end;

procedure TFakeWriteTarget.ValidateChanges(
  const Changes: TDBParadoxWriteChanges);
var
  WorkingRows: TStringList;
  Index: SizeInt;
  RowIndex: Integer;
  Key: string;
begin
  WorkingRows := TStringList.Create;
  try
    WorkingRows.Assign(FRows);
    for Index := 0 to High(Changes) do
    begin
      Key := KeyFor(Changes[Index]);
      RowIndex := WorkingRows.IndexOfName(Key);
      if Changes[Index].Kind = dpwInsert then
      begin
        if RowIndex >= 0 then
          raise Exception.Create('Fake target found a duplicate insert.');
        WorkingRows.Add(Key + '=' +
          StringOfBytes(Changes[Index].AfterImage));
        Continue;
      end;
      if (RowIndex < 0) or
        (WorkingRows.ValueFromIndex[RowIndex] <>
         StringOfBytes(Changes[Index].BeforeImage)) then
        raise Exception.Create('Fake target found a stale before-image.');
      if Changes[Index].Kind = dpwUpdate then
        WorkingRows.ValueFromIndex[RowIndex] :=
          StringOfBytes(Changes[Index].AfterImage)
      else
        WorkingRows.Delete(RowIndex);
    end;
  finally
    WorkingRows.Free;
  end;
end;

function TFakeWriteTarget.ApplyChange(
  const Change: TDBParadoxWriteChange): TBytes;
var
  Key: string;
  PreviousValue: string;
begin
  Inc(FApplyCount);
  if FApplyCount = FFailApplyAt then
    raise Exception.CreateFmt('Injected apply failure %d.', [FApplyCount]);
  Key := KeyFor(Change);
  if ContainsRow(Key) then
    PreviousValue := GetRow(Key)
  else
    PreviousValue := #1;

  case Change.Kind of
    dpwInsert:
      begin
        if PreviousValue <> #1 then
          raise Exception.Create('Fake target insert row already exists.');
        SetRow(Key, StringOfBytes(Change.AfterImage));
      end;
    dpwUpdate:
      begin
        if PreviousValue = #1 then
          raise Exception.Create('Fake target update row is missing.');
        SetRow(Key, StringOfBytes(Change.AfterImage));
      end;
    dpwDelete:
      begin
        if PreviousValue = #1 then
          raise Exception.Create('Fake target delete row is missing.');
        SetRow(Key, #1);
      end;
  end;
  Result := Bytes(PreviousValue);
end;

procedure TFakeWriteTarget.CompensateChange(
  const Change: TDBParadoxWriteChange; const UndoToken: TBytes);
var
  PreviousValue: string;
begin
  FCompensationOrder.Add(IntToStr(Change.RowID));
  if FFailCompensation then
    raise Exception.Create('Injected compensation failure.');
  PreviousValue := StringOfBytes(UndoToken);
  SetRow(KeyFor(Change), PreviousValue);
end;

procedure TFakeWriteTarget.Seed(const TableName: string; RowID: Int64;
  const Value: string);
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := TableName;
  Change.RowID := RowID;
  SetRow(KeyFor(Change), Value);
end;

function TFakeWriteTarget.RowValue(const TableName: string;
  RowID: Int64): string;
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := TableName;
  Change.RowID := RowID;
  Result := GetRow(KeyFor(Change));
end;

procedure TTestDBParadoxWriteBuffer.
  StagedChangesAreVisibleAndRollbackDiscardsThem;
var
  Buffer: TDBParadoxWriteBuffer;
  RowID: Int64;
  Exists: Boolean;
  Image: TBytes;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    RowID := Buffer.StageInsert('People.DB', Bytes('new'));
    CheckTrue(RowID < 0);
    Buffer.ResolveRow('People.DB', RowID, False, nil, Exists, Image);
    CheckTrue(Exists);
    CheckEquals('new', StringOfBytes(Image));
    Buffer.Rollback;
    CheckEquals(Ord(dpwsRolledBack), Ord(Buffer.State));
    CheckEquals(0, Buffer.ChangeCount);
    Buffer.ResolveRow('People.DB', RowID, False, nil, Exists, Image);
    CheckFalse(Exists);
  finally
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  ImagesAreCopiedAcrossTheBufferBoundary;
var
  Buffer: TDBParadoxWriteBuffer;
  InputImage: TBytes;
  Changes: TDBParadoxWriteChanges;
  Exists: Boolean;
  Image: TBytes;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    InputImage := Bytes('before');
    Buffer.StageUpdate('People.DB', 4, InputImage, Bytes('after'));
    InputImage[0] := Ord('X');
    Changes := Buffer.Changes;
    Changes[0].AfterImage[0] := Ord('X');
    Buffer.ResolveRow('People.DB', 4, True, Bytes('before'),
      Exists, Image);
    CheckTrue(Exists);
    CheckEquals('after', StringOfBytes(Image));
    Image[0] := Ord('X');
    Buffer.ResolveRow('People.DB', 4, True, Bytes('before'),
      Exists, Image);
    CheckEquals('after', StringOfBytes(Image));
  finally
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.SuccessfulCommitAppliesChanges;
var
  Buffer: TDBParadoxWriteBuffer;
  Target: IDBParadoxWriteTarget;
  Fake: TFakeWriteTarget;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  Fake := TFakeWriteTarget.Create;
  Target := Fake;
  try
    Fake.Seed('People.DB', 4, 'before');
    Buffer.StageUpdate('People.DB', 4, Bytes('before'), Bytes('after'));
    Buffer.StageInsert('People.DB', Bytes('inserted'));
    Buffer.Commit(Target);
    CheckEquals(Ord(dpwsCommitted), Ord(Buffer.State));
    CheckEquals(0, Buffer.ChangeCount);
    CheckEquals('after', Fake.RowValue('People.DB', 4));
    CheckEquals(2, Fake.ApplyCount);
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  FailedCommitCompensatesAppliedChangesInReverse;
var
  Buffer: TDBParadoxWriteBuffer;
  Target: IDBParadoxWriteTarget;
  Fake: TFakeWriteTarget;
  RaisedExpectedError: Boolean;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  Fake := TFakeWriteTarget.Create;
  Target := Fake;
  try
    Fake.Seed('People.DB', 1, 'first-before');
    Fake.Seed('People.DB', 2, 'second-before');
    Buffer.StageUpdate('People.DB', 1, Bytes('first-before'),
      Bytes('first-after'));
    Buffer.StageUpdate('People.DB', 2, Bytes('second-before'),
      Bytes('second-after'));
    Buffer.StageInsert('People.DB', Bytes('inserted'));
    Fake.FailApplyAt := 3;
    RaisedExpectedError := False;
    try
      Buffer.Commit(Target);
    except
      on E: EDBParadoxCommitError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(Ord(dpwsActive), Ord(Buffer.State));
    CheckEquals('first-before', Fake.RowValue('People.DB', 1));
    CheckEquals('second-before', Fake.RowValue('People.DB', 2));
    CheckEquals(2, Fake.CompensationOrder.Count);
    CheckEquals('2', Fake.CompensationOrder[0]);
    CheckEquals('1', Fake.CompensationOrder[1]);
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.FailedCompensationPoisonsTheBuffer;
var
  Buffer: TDBParadoxWriteBuffer;
  Target: IDBParadoxWriteTarget;
  Fake: TFakeWriteTarget;
  RaisedExpectedError: Boolean;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  Fake := TFakeWriteTarget.Create;
  Target := Fake;
  try
    Fake.Seed('People.DB', 1, 'before');
    Buffer.StageUpdate('People.DB', 1, Bytes('before'), Bytes('after'));
    Buffer.StageInsert('People.DB', Bytes('inserted'));
    Fake.FailApplyAt := 2;
    Fake.FailCompensation := True;
    RaisedExpectedError := False;
    try
      Buffer.Commit(Target);
    except
      on E: EDBParadoxCompensationError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(Ord(dpwsPoisoned), Ord(Buffer.State));
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxWriteBuffer);

end.
