unit DBParadoxWriteBuffer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  EDBParadoxWriteBufferError = class(Exception);
  EDBParadoxCommitError = class(EDBParadoxWriteBufferError);
  EDBParadoxCompensationError = class(EDBParadoxWriteBufferError);

  TDBParadoxWriteKind = (dpwInsert, dpwUpdate, dpwDelete);
  TDBParadoxWriteState = (
    dpwsActive,
    dpwsCommitting,
    dpwsCommitted,
    dpwsRolledBack,
    dpwsPoisoned
  );

  TDBParadoxWriteChange = record
    TableName: string;
    RowID: Int64;
    Kind: TDBParadoxWriteKind;
    BeforeImage: TBytes;
    AfterImage: TBytes;
  end;

  TDBParadoxWriteChanges = array of TDBParadoxWriteChange;

  IDBParadoxWriteTarget = interface
    ['{CD813297-5664-4D3E-83BB-42498E1E589A}']
    procedure ValidateChanges(const AChanges: TDBParadoxWriteChanges);
    { Each apply must either finish and return an undo token, or leave its
      target unchanged. Compensation restores the exact prior state. }
    function ApplyChange(const AChange: TDBParadoxWriteChange): TBytes;
    procedure CompensateChange(const AChange: TDBParadoxWriteChange;
      const AUndoToken: TBytes);
  end;

  TDBParadoxWriteBuffer = class
  private
    FChanges: TDBParadoxWriteChanges;
    FNextTemporaryRowID: Int64;
    FState: TDBParadoxWriteState;
    function GetChangeCount: Integer;
    procedure RequireActive;
    procedure AddChange(const AChange: TDBParadoxWriteChange);
  public
    constructor Create;
    function StageInsert(const ATableName: string;
      const AAfterImage: TBytes): Int64;
    procedure StageUpdate(const ATableName: string; ARowID: Int64;
      const ABeforeImage, AAfterImage: TBytes);
    procedure StageDelete(const ATableName: string; ARowID: Int64;
      const ABeforeImage: TBytes);
    procedure ResolveRow(const ATableName: string; ARowID: Int64;
      ABaseExists: Boolean; const ABaseImage: TBytes;
      out AExists: Boolean; out AImage: TBytes);
    function Changes: TDBParadoxWriteChanges;
    procedure Commit(const ATarget: IDBParadoxWriteTarget);
    procedure Rollback;
    property State: TDBParadoxWriteState read FState;
    property ChangeCount: Integer read GetChangeCount;
  end;

implementation

function SameByteArrays(const ALeft, ARight: TBytes): Boolean;
var
  Index: SizeInt;
begin
  if Length(ALeft) <> Length(ARight) then
    Exit(False);
  for Index := 0 to High(ALeft) do
    if ALeft[Index] <> ARight[Index] then
      Exit(False);
  Result := True;
end;

constructor TDBParadoxWriteBuffer.Create;
begin
  inherited Create;
  FNextTemporaryRowID := -1;
  FState := dpwsActive;
end;

procedure TDBParadoxWriteBuffer.RequireActive;
begin
  if FState = dpwsPoisoned then
    raise EDBParadoxWriteBufferError.Create(
      'The write transaction is poisoned after a compensation failure.');
  if FState <> dpwsActive then
    raise EDBParadoxWriteBufferError.CreateFmt(
      'The write transaction is not active (state %d).', [Ord(FState)]);
end;

procedure TDBParadoxWriteBuffer.AddChange(
  const AChange: TDBParadoxWriteChange);
var
  ChangeIndex: SizeInt;
  TemporaryRowExists: Boolean;
  TemporaryRowImage: TBytes;
begin
  RequireActive;
  if Trim(AChange.TableName) = '' then
    raise EDBParadoxWriteBufferError.Create(
      'A table name is required for a staged write.');
  if (AChange.Kind = dpwInsert) and (Length(AChange.AfterImage) = 0) then
    raise EDBParadoxWriteBufferError.Create(
      'A staged insert requires a nonempty after-image.');
  if (AChange.Kind = dpwUpdate) and
    ((Length(AChange.BeforeImage) = 0) or
     (Length(AChange.AfterImage) = 0)) then
    raise EDBParadoxWriteBufferError.Create(
      'A staged update requires before- and after-images.');
  if (AChange.Kind = dpwDelete) and (Length(AChange.BeforeImage) = 0) then
    raise EDBParadoxWriteBufferError.Create(
      'A staged delete requires a before-image.');
  if (AChange.RowID < 0) and (AChange.Kind <> dpwInsert) then
  begin
    ResolveRow(AChange.TableName, AChange.RowID, False, nil,
      TemporaryRowExists, TemporaryRowImage);
    if not TemporaryRowExists then
      raise EDBParadoxWriteBufferError.Create(
        'A staged update/delete cannot resolve its temporary row.');
    if not SameByteArrays(TemporaryRowImage, AChange.BeforeImage) then
      raise EDBParadoxWriteBufferError.Create(
        'The before-image does not match the staged temporary row.');
  end;

  ChangeIndex := Length(FChanges);
  SetLength(FChanges, ChangeIndex + 1);
  FChanges[ChangeIndex] := AChange;
  FChanges[ChangeIndex].BeforeImage :=
    Copy(AChange.BeforeImage, 0, Length(AChange.BeforeImage));
  FChanges[ChangeIndex].AfterImage :=
    Copy(AChange.AfterImage, 0, Length(AChange.AfterImage));
end;

function TDBParadoxWriteBuffer.StageInsert(const ATableName: string;
  const AAfterImage: TBytes): Int64;
var
  Change: TDBParadoxWriteChange;
begin
  RequireActive;
  Result := FNextTemporaryRowID;
  Dec(FNextTemporaryRowID);
  Change.TableName := ATableName;
  Change.RowID := Result;
  Change.Kind := dpwInsert;
  Change.BeforeImage := nil;
  Change.AfterImage := AAfterImage;
  AddChange(Change);
end;

procedure TDBParadoxWriteBuffer.StageUpdate(const ATableName: string;
  ARowID: Int64; const ABeforeImage, AAfterImage: TBytes);
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := ATableName;
  Change.RowID := ARowID;
  Change.Kind := dpwUpdate;
  Change.BeforeImage := ABeforeImage;
  Change.AfterImage := AAfterImage;
  AddChange(Change);
end;

procedure TDBParadoxWriteBuffer.StageDelete(const ATableName: string;
  ARowID: Int64; const ABeforeImage: TBytes);
var
  Change: TDBParadoxWriteChange;
begin
  Change.TableName := ATableName;
  Change.RowID := ARowID;
  Change.Kind := dpwDelete;
  Change.BeforeImage := ABeforeImage;
  Change.AfterImage := nil;
  AddChange(Change);
end;

procedure TDBParadoxWriteBuffer.ResolveRow(const ATableName: string;
  ARowID: Int64; ABaseExists: Boolean; const ABaseImage: TBytes;
  out AExists: Boolean; out AImage: TBytes);
var
  Index: SizeInt;
begin
  AExists := ABaseExists;
  AImage := Copy(ABaseImage, 0, Length(ABaseImage));
  for Index := 0 to High(FChanges) do
    if (FChanges[Index].RowID = ARowID) and
      SameText(FChanges[Index].TableName, ATableName) then
      case FChanges[Index].Kind of
        dpwInsert, dpwUpdate:
          begin
            AExists := True;
            AImage := Copy(FChanges[Index].AfterImage, 0,
              Length(FChanges[Index].AfterImage));
          end;
        dpwDelete:
          begin
            AExists := False;
            AImage := nil;
          end;
      end;
end;

function TDBParadoxWriteBuffer.Changes: TDBParadoxWriteChanges;
var
  Index: SizeInt;
begin
  Result := Copy(FChanges, 0, Length(FChanges));
  for Index := 0 to High(Result) do
  begin
    Result[Index].BeforeImage :=
      Copy(FChanges[Index].BeforeImage, 0,
        Length(FChanges[Index].BeforeImage));
    Result[Index].AfterImage :=
      Copy(FChanges[Index].AfterImage, 0,
        Length(FChanges[Index].AfterImage));
  end;
end;

function TDBParadoxWriteBuffer.GetChangeCount: Integer;
begin
  Result := Length(FChanges);
end;

procedure TDBParadoxWriteBuffer.Commit(const ATarget: IDBParadoxWriteTarget);
var
  UndoTokens: array of TBytes;
  AppliedCount: SizeInt;
  Index: SizeInt;
  CompensationErrors: TStringList;
  OriginalErrorClass: string;
  OriginalErrorMessage: string;
begin
  RequireActive;
  if not Assigned(ATarget) then
    raise EDBParadoxWriteBufferError.Create(
      'A write target is required to commit staged changes.');

  UndoTokens := nil;
  SetLength(UndoTokens, Length(FChanges));
  ATarget.ValidateChanges(FChanges);
  AppliedCount := 0;
  FState := dpwsCommitting;
  try
    try
      for Index := 0 to High(FChanges) do
      begin
        UndoTokens[Index] := ATarget.ApplyChange(FChanges[Index]);
        Inc(AppliedCount);
      end;
      SetLength(FChanges, 0);
      FState := dpwsCommitted;
    except
      on E: Exception do
      begin
        OriginalErrorClass := E.ClassName;
        OriginalErrorMessage := E.Message;
        CompensationErrors := TStringList.Create;
        try
          for Index := AppliedCount - 1 downto 0 do
            try
              ATarget.CompensateChange(FChanges[Index], UndoTokens[Index]);
            except
              on CompensationError: Exception do
                CompensationErrors.Add(Format('%s: %s',
                  [CompensationError.ClassName,
                   CompensationError.Message]));
            end;

          if CompensationErrors.Count > 0 then
          begin
            FState := dpwsPoisoned;
            raise EDBParadoxCompensationError.CreateFmt(
              'Commit failed (%s: %s); compensation also failed: %s',
              [OriginalErrorClass, OriginalErrorMessage,
               CompensationErrors.Text]);
          end;
          FState := dpwsActive;
          raise EDBParadoxCommitError.CreateFmt(
            'Commit failed (%s): %s. Applied changes were compensated.',
            [OriginalErrorClass, OriginalErrorMessage]);
        finally
          CompensationErrors.Free;
        end;
      end;
    end;
  except
    if FState = dpwsCommitting then
      FState := dpwsActive;
    raise;
  end;
end;

procedure TDBParadoxWriteBuffer.Rollback;
begin
  RequireActive;
  SetLength(FChanges, 0);
  FState := dpwsRolledBack;
end;

end.
