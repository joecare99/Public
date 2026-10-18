unit tst_DBParadoxWriteBufferTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxWriteBuffer = class(TTestCase)
  published
    procedure StagedUpdateIsVisibleOnlyInsideItsBuffer;
    procedure StagedByteImagesAreIsolatedFromCallerCopies;
    procedure StagedInsertCanBeUpdatedAndDeletedBeforeCommit;
    procedure TemporaryRowUpdatesRequireTheCurrentImage;
    procedure ValidationFailureDoesNotCallWriter;
    procedure StaleBeforeImageIsRejectedBeforeApply;
    procedure CommitAppliesTheCompleteWriteSet;
    procedure CommitFailureCompensatesInReverseOrder;
    procedure CompensationFailurePoisonsTheBuffer;
    procedure TemporaryRowsCannotBeUpdatedAfterDeletion;
  end;

implementation

uses
  Classes, SysUtils, DBParadoxWriteBuffer;

type
  TFakeWriteTarget = class(TInterfacedObject, IDBParadoxWriteTarget)
  private
    FRows: TStringList;
    FApplyCount: Integer;
    FCompensateCount: Integer;
    FFailApplyAt: Integer;
    FFailCompensateAt: Integer;
    FFailValidation: Boolean;
    FCompensationOrder: TStringList;
    function KeyFor(const AChange: TDBParadoxWriteChange): string;
    function GetRow(const AKey: string): string;
    procedure SetRow(const AKey, AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ValidateChanges(const AChanges: TDBParadoxWriteChanges);
    function ApplyChange(const AChange: TDBParadoxWriteChange): TBytes;
    procedure CompensateChange(const AChange: TDBParadoxWriteChange;
      const AUndoToken: TBytes);
    procedure Seed(const ATableName: string; ARowID: Int64;
      const AValue: string);
    function RowValue(const ATableName: string; ARowID: Int64): string;
    property FailApplyAt: Integer read FFailApplyAt write FFailApplyAt;
    property FailCompensateAt: Integer read FFailCompensateAt
      write FFailCompensateAt;
    property FailValidation: Boolean read FFailValidation
      write FFailValidation;
    property CompensationOrder: TStringList read FCompensationOrder;
  end;

function Bytes(const AValue: string): TBytes;
begin
  Result := nil;
  SetLength(Result, Length(AValue));
  if Length(AValue) > 0 then
    Move(AValue[1], Result[0], Length(AValue));
end;

function StringOfBytes(const AValue: TBytes): string;
begin
  Result := '';
  SetLength(Result, Length(AValue));
  if Length(AValue) > 0 then
    Move(AValue[0], Result[1], Length(AValue));
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
  const AChange: TDBParadoxWriteChange): string;
begin
  Result := LowerCase(AChange.TableName) + '#' + IntToStr(AChange.RowID);
end;

function TFakeWriteTarget.GetRow(const AKey: string): string;
var
  Index: Integer;
begin
  Index := FRows.IndexOfName(AKey);
  if Index < 0 then
    Exit('');
  Result := FRows.ValueFromIndex[Index];
end;

procedure TFakeWriteTarget.SetRow(const AKey, AValue: string);
var
  Index: Integer;
begin
  Index := FRows.IndexOfName(AKey);
  if Index >= 0 then
    FRows.Delete(Index);
  if AValue <> #1 then
    FRows.Add(AKey + '=' + AValue);
end;

function TFakeWriteTarget.ApplyChange(
  const AChange: TDBParadoxWriteChange): TBytes;
var
  Key: string;
  PreviousValue: string;
begin
  Inc(FApplyCount);
  if FApplyCount = FFailApplyAt then
    raise Exception.CreateFmt('Injected apply failure %d.', [FApplyCount]);
  Key := KeyFor(AChange);
  PreviousValue := GetRow(Key);
  case AChange.Kind of
    dpwInsert:
      begin
        if FRows.IndexOfName(Key) >= 0 then
          raise Exception.Create('Duplicate fake row insert.');
        SetRow(Key, StringOfBytes(AChange.AfterImage));
      end;
    dpwUpdate:
      begin
        if FRows.IndexOfName(Key) < 0 then
          raise Exception.Create('Fake update target is missing.');
        SetRow(Key, StringOfBytes(AChange.AfterImage));
      end;
    dpwDelete:
      begin
        if FRows.IndexOfName(Key) < 0 then
          raise Exception.Create('Fake delete target is missing.');
        SetRow(Key, #1);
      end;
  end;
  if PreviousValue = '' then
    Result := Bytes(#1)
  else
    Result := Bytes(PreviousValue);
end;

procedure TFakeWriteTarget.ValidateChanges(
  const AChanges: TDBParadoxWriteChanges);
var
  WorkingRows: TStringList;
  Index: SizeInt;
  Key: string;
  RowIndex: Integer;
  CurrentValue: string;
begin
  if FFailValidation then
    raise Exception.Create('Injected write-set validation failure.');
  WorkingRows := TStringList.Create;
  try
    WorkingRows.Assign(FRows);
    for Index := 0 to High(AChanges) do
    begin
      Key := KeyFor(AChanges[Index]);
      RowIndex := WorkingRows.IndexOfName(Key);
      if AChanges[Index].Kind = dpwInsert then
      begin
        if RowIndex >= 0 then
          raise Exception.Create('Fake validation found a duplicate insert.');
        WorkingRows.Add(Key + '=' +
          StringOfBytes(AChanges[Index].AfterImage));
        Continue;
      end;

      if RowIndex < 0 then
        raise Exception.Create('Fake validation found a missing target row.');
      CurrentValue := WorkingRows.ValueFromIndex[RowIndex];
      if CurrentValue <> StringOfBytes(AChanges[Index].BeforeImage) then
        raise Exception.Create('Fake validation found a stale before-image.');
      if AChanges[Index].Kind = dpwUpdate then
        WorkingRows.ValueFromIndex[RowIndex] :=
          StringOfBytes(AChanges[Index].AfterImage)
      else
        WorkingRows.Delete(RowIndex);
    end;
  finally
    WorkingRows.Free;
  end;
end;

procedure TFakeWriteTarget.CompensateChange(
  const AChange: TDBParadoxWriteChange; const AUndoToken: TBytes);
var
  PreviousValue: string;
begin
  Inc(FCompensateCount);
  FCompensationOrder.Add(IntToStr(AChange.RowID));
  if FCompensateCount = FFailCompensateAt then
    raise Exception.CreateFmt('Injected compensation failure %d.',
      [FCompensateCount]);
  PreviousValue := StringOfBytes(AUndoToken);
  if PreviousValue = #1 then
    SetRow(KeyFor(AChange), #1)
  else
    SetRow(KeyFor(AChange), PreviousValue);
end;

procedure TFakeWriteTarget.Seed(const ATableName: string; ARowID: Int64;
  const AValue: string);
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := ATableName;
  Change.RowID := ARowID;
  SetRow(KeyFor(Change), AValue);
end;

function TFakeWriteTarget.RowValue(const ATableName: string;
  ARowID: Int64): string;
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := ATableName;
  Change.RowID := ARowID;
  Result := GetRow(KeyFor(Change));
end;

procedure TTestDBParadoxWriteBuffer.StagedUpdateIsVisibleOnlyInsideItsBuffer;
var
  Buffer: TDBParadoxWriteBuffer;
  OtherBuffer: TDBParadoxWriteBuffer;
  Exists: Boolean;
  Image: TBytes;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  OtherBuffer := TDBParadoxWriteBuffer.Create;
  try
    Buffer.StageUpdate('People.DB', 4, Bytes('old'), Bytes('new'));
    Buffer.ResolveRow('People.DB', 4, True, Bytes('old'), Exists, Image);
    CheckTrue(Exists);
    CheckEquals('new', StringOfBytes(Image));
    OtherBuffer.ResolveRow('People.DB', 4, True, Bytes('old'), Exists, Image);
    CheckTrue(Exists);
    CheckEquals('old', StringOfBytes(Image));

    Buffer.Rollback;
    CheckEquals(Ord(dpwsRolledBack), Ord(Buffer.State));
    Buffer.ResolveRow('People.DB', 4, True, Bytes('old'), Exists, Image);
    CheckTrue(Exists);
    CheckEquals('old', StringOfBytes(Image));
  finally
    OtherBuffer.Free;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  StagedByteImagesAreIsolatedFromCallerCopies;
var
  Buffer: TDBParadoxWriteBuffer;
  InputImage: TBytes;
  Image: TBytes;
  Changes: TDBParadoxWriteChanges;
  Exists: Boolean;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    InputImage := Bytes('old');
    Buffer.StageUpdate('People.DB', 4, InputImage, Bytes('new'));
    InputImage[0] := Ord('X');

    Changes := Buffer.Changes;
    Changes[0].AfterImage[0] := Ord('X');
    Buffer.ResolveRow('People.DB', 4, True, Bytes('old'), Exists, Image);
    CheckTrue(Exists);
    CheckEquals('new', StringOfBytes(Image));

    Image[0] := Ord('X');
    Buffer.ResolveRow('People.DB', 4, True, Bytes('old'), Exists, Image);
    CheckEquals('new', StringOfBytes(Image));
  finally
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  StagedInsertCanBeUpdatedAndDeletedBeforeCommit;
var
  Buffer: TDBParadoxWriteBuffer;
  RowID: Int64;
  Exists: Boolean;
  Image: TBytes;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    RowID := Buffer.StageInsert('People.DB', Bytes('first'));
    CheckTrue(RowID < 0);
    Buffer.ResolveRow('People.DB', RowID, False, nil, Exists, Image);
    CheckTrue(Exists);
    CheckEquals('first', StringOfBytes(Image));

    Buffer.StageUpdate('People.DB', RowID, Bytes('first'), Bytes('second'));
    Buffer.ResolveRow('People.DB', RowID, False, nil, Exists, Image);
    CheckTrue(Exists);
    CheckEquals('second', StringOfBytes(Image));

    Buffer.StageDelete('People.DB', RowID, Bytes('second'));
    Buffer.ResolveRow('People.DB', RowID, False, nil, Exists, Image);
    CheckFalse(Exists);
    CheckEquals(3, Buffer.ChangeCount);
  finally
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  TemporaryRowUpdatesRequireTheCurrentImage;
var
  Buffer: TDBParadoxWriteBuffer;
  RowID: Int64;
  RaisedExpectedError: Boolean;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    RowID := Buffer.StageInsert('People.DB', Bytes('inserted'));
    RaisedExpectedError := False;
    try
      Buffer.StageUpdate('People.DB', RowID, Bytes('stale'), Bytes('changed'));
    except
      on E: EDBParadoxWriteBufferError do
        RaisedExpectedError := Pos('before-image', E.Message) > 0;
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(1, Buffer.ChangeCount);
  finally
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.ValidationFailureDoesNotCallWriter;
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
    Buffer.StageInsert('People.DB', Bytes('row'));
    Fake.FailValidation := True;
    RaisedExpectedError := False;
    try
      Buffer.Commit(Target);
    except
      on E: Exception do
        RaisedExpectedError := E.Message =
          'Injected write-set validation failure.';
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(0, Fake.FApplyCount);
    CheckEquals(Ord(dpwsActive), Ord(Buffer.State));
    CheckEquals(1, Buffer.ChangeCount);
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.StaleBeforeImageIsRejectedBeforeApply;
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
    Fake.Seed('People.DB', 1, 'current');
    Buffer.StageUpdate('People.DB', 1, Bytes('stale'), Bytes('new'));
    RaisedExpectedError := False;
    try
      Buffer.Commit(Target);
    except
      on E: Exception do
        RaisedExpectedError := E.Message =
          'Fake validation found a stale before-image.';
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(0, Fake.FApplyCount);
    CheckEquals('current', Fake.RowValue('People.DB', 1));
    CheckEquals(Ord(dpwsActive), Ord(Buffer.State));
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.CommitAppliesTheCompleteWriteSet;
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
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.CommitFailureCompensatesInReverseOrder;
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
    Fake.Seed('People.DB', 1, 'one-before');
    Fake.Seed('People.DB', 2, 'two-before');
    Buffer.StageUpdate('People.DB', 1, Bytes('one-before'), Bytes('one-after'));
    Buffer.StageUpdate('People.DB', 2, Bytes('two-before'), Bytes('two-after'));
    Buffer.StageInsert('People.DB', Bytes('will-fail'));
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
    CheckEquals(3, Buffer.ChangeCount);
    CheckEquals('one-before', Fake.RowValue('People.DB', 1));
    CheckEquals('two-before', Fake.RowValue('People.DB', 2));
    CheckEquals(2, Fake.CompensationOrder.Count);
    CheckEquals('2', Fake.CompensationOrder[0]);
    CheckEquals('1', Fake.CompensationOrder[1]);
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.CompensationFailurePoisonsTheBuffer;
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
    Buffer.StageInsert('People.DB', Bytes('will-fail'));
    Fake.FailApplyAt := 2;
    Fake.FailCompensateAt := 1;

    RaisedExpectedError := False;
    try
      Buffer.Commit(Target);
    except
      on E: EDBParadoxCompensationError do
        RaisedExpectedError := Pos('Injected apply failure',
          E.Message) > 0;
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(Ord(dpwsPoisoned), Ord(Buffer.State));
    CheckException(@Buffer.Rollback, EDBParadoxWriteBufferError);
  finally
    Target := nil;
    Buffer.Free;
  end;
end;

procedure TTestDBParadoxWriteBuffer.
  TemporaryRowsCannotBeUpdatedAfterDeletion;
var
  Buffer: TDBParadoxWriteBuffer;
  RowID: Int64;
  RaisedExpectedError: Boolean;
begin
  Buffer := TDBParadoxWriteBuffer.Create;
  try
    RowID := Buffer.StageInsert('People.DB', Bytes('new'));
    Buffer.StageDelete('People.DB', RowID, Bytes('new'));
    RaisedExpectedError := False;
    try
      Buffer.StageUpdate('People.DB', RowID, Bytes('new'), Bytes('bad'));
    except
      on E: EDBParadoxWriteBufferError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
  finally
    Buffer.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxWriteBuffer);

end.
