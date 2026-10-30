unit tst_AHW52_MarriagePairTransactionContractTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MarriagePairTransactionContract = class(TTestCase)
  published
    procedure TestWritesReciprocalRowsWithIdenticalDetailsAndCommits;
    procedure TestSecondAppendFailureRollsBackBothRows;
    procedure TestCommitFailureRollsBackAndPropagates;
    procedure TestRollbackFailureReportsBothFailures;
    procedure TestRejectsSelfMarriageBeforeStartingTransaction;
    procedure TestRejectsNonPositivePersonNumber;
    procedure TestBeginFailurePropagatesWithoutRollback;
    procedure TestRejectsMissingTransaction;
  end;

implementation

uses
  SysUtils, GenealogyDataModuleAccess, MarriagePairTransactionContract;

type
  TStoredMarriageRecord = record
    PersonNumber: Integer;
    PartnerNumber: Integer;
    Details: TMarriageDetails;
  end;
  TStoredMarriageRecords = array of TStoredMarriageRecord;

  TSyntheticMarriageTransaction = class(TInterfacedObject,
    IMarriagePairTransaction)
  private
    FPending: TStoredMarriageRecords;
    FCommitted: TStoredMarriageRecords;
    FAppendCount: Integer;
    FFailAppendAt: Integer;
    FFailBegin: Boolean;
    FFailCommit: Boolean;
    FFailRollback: Boolean;
    FBeginCount: Integer;
    FCommitCount: Integer;
    FRollbackCount: Integer;
    function GetPendingCount: Integer;
    function GetCommittedCount: Integer;
  public
    procedure BeginTransaction;
    procedure AppendMarriageRecord(const PersonNumber, PartnerNumber: Integer;
      const Details: TMarriageDetails);
    procedure CommitTransaction;
    procedure RollbackTransaction;
    property AppendCount: Integer read FAppendCount;
    property BeginCount: Integer read FBeginCount;
    property CommitCount: Integer read FCommitCount;
    property RollbackCount: Integer read FRollbackCount;
    property FailAppendAt: Integer read FFailAppendAt write FFailAppendAt;
    property FailBegin: Boolean read FFailBegin write FFailBegin;
    property FailCommit: Boolean read FFailCommit write FFailCommit;
    property FailRollback: Boolean read FFailRollback write FFailRollback;
    property PendingCount: Integer read GetPendingCount;
    property CommittedCount: Integer read GetCommittedCount;
    function CommittedRecord(const Index: Integer): TStoredMarriageRecord;
  end;

  EInjectedMarriageFailure = class(Exception);

function SameDetails(const Left, Right: TMarriageDetails): Boolean;
begin
  Result :=
    (Left.Htag = Right.Htag) and
    (Left.Hmonat = Right.Hmonat) and
    (Left.Hjahr = Right.Hjahr) and
    (Left.Hort = Right.Hort) and
    (Left.Trauz = Right.Trauz) and
    (Left.Satag = Right.Satag) and
    (Left.Samonat = Right.Samonat) and
    (Left.Sajahr = Right.Sajahr) and
    (Left.Saort = Right.Saort) and
    (Left.Satrauz = Right.Satrauz) and
    (Left.Verbind = Right.Verbind) and
    (Left.Schtag = Right.Schtag) and
    (Left.Schmonat = Right.Schmonat) and
    (Left.Schjahr = Right.Schjahr) and
    (Left.Schort = Right.Schort) and
    (Left.Hqu = Right.Hqu) and
    (Left.Saqu = Right.Saqu) and
    (Left.Schqu = Right.Schqu);
end;

procedure TSyntheticMarriageTransaction.BeginTransaction;
begin
  Inc(FBeginCount);
  if FFailBegin then
    raise EInjectedMarriageFailure.Create('Injected begin failure.');
  SetLength(FPending, 0);
  FAppendCount := 0;
end;

procedure TSyntheticMarriageTransaction.AppendMarriageRecord(
  const PersonNumber, PartnerNumber: Integer;
  const Details: TMarriageDetails);
var
  RecordIndex: Integer;
begin
  Inc(FAppendCount);
  RecordIndex := Length(FPending);
  SetLength(FPending, RecordIndex + 1);
  FPending[RecordIndex].PersonNumber := PersonNumber;
  FPending[RecordIndex].PartnerNumber := PartnerNumber;
  FPending[RecordIndex].Details := Details;
  if FFailAppendAt = FAppendCount then
    raise EInjectedMarriageFailure.CreateFmt(
      'Injected append failure %d.', [FAppendCount]);
end;

procedure TSyntheticMarriageTransaction.CommitTransaction;
var
  OldLength, Index: Integer;
begin
  Inc(FCommitCount);
  if FFailCommit then
    raise EInjectedMarriageFailure.Create('Injected commit failure.');
  OldLength := Length(FCommitted);
  SetLength(FCommitted, OldLength + Length(FPending));
  for Index := 0 to High(FPending) do
    FCommitted[OldLength + Index] := FPending[Index];
  SetLength(FPending, 0);
end;

procedure TSyntheticMarriageTransaction.RollbackTransaction;
begin
  Inc(FRollbackCount);
  if FFailRollback then
    raise EInjectedMarriageFailure.Create('Injected rollback failure.');
  SetLength(FPending, 0);
end;

function TSyntheticMarriageTransaction.CommittedRecord(
  const Index: Integer): TStoredMarriageRecord;
begin
  Result := FCommitted[Index];
end;

function TSyntheticMarriageTransaction.GetPendingCount: Integer;
begin
  Result := Length(FPending);
end;

function TSyntheticMarriageTransaction.GetCommittedCount: Integer;
begin
  Result := Length(FCommitted);
end;

function CreateSyntheticDetails: TMarriageDetails;
begin
  Result.Htag := '01';
  Result.Hmonat := '02';
  Result.Hjahr := '1900';
  Result.Hort := 'Ort';
  Result.Trauz := 'Kirche';
  Result.Satag := '03';
  Result.Samonat := '04';
  Result.Sajahr := '1901';
  Result.Saort := 'Standesamt';
  Result.Satrauz := 'Register';
  Result.Verbind := 'Eheschliessung';
  Result.Schtag := '05';
  Result.Schmonat := '06';
  Result.Schjahr := '1902';
  Result.Schort := 'Scheidungsort';
  Result.Hqu := 'QH';
  Result.Saqu := 'QS';
  Result.Schqu := 'QD';
end;

function CreateSyntheticRequest: TMarriagePairRequest;
begin
  Result := CreateMarriagePairRequest(101, 202, CreateSyntheticDetails);
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestWritesReciprocalRowsWithIdenticalDetailsAndCommits;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
  Request: TMarriagePairRequest;
  FirstRecord, SecondRecord: TStoredMarriageRecord;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  Transaction := TransactionObject;
  Request := CreateSyntheticRequest;

  WriteMarriagePairAtomically(Transaction, Request);

  AssertEquals(1, TransactionObject.BeginCount);
  AssertEquals(2, TransactionObject.AppendCount);
  AssertEquals(1, TransactionObject.CommitCount);
  AssertEquals(0, TransactionObject.RollbackCount);
  AssertEquals(2, TransactionObject.CommittedCount);
  FirstRecord := TransactionObject.CommittedRecord(0);
  SecondRecord := TransactionObject.CommittedRecord(1);
  AssertEquals(101, FirstRecord.PersonNumber);
  AssertEquals(202, FirstRecord.PartnerNumber);
  AssertEquals(202, SecondRecord.PersonNumber);
  AssertEquals(101, SecondRecord.PartnerNumber);
  AssertTrue(SameDetails(FirstRecord.Details, Request.Details));
  AssertTrue(SameDetails(SecondRecord.Details, Request.Details));
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestSecondAppendFailureRollsBackBothRows;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  TransactionObject.FailAppendAt := 2;
  Transaction := TransactionObject;
  try
    WriteMarriagePairAtomically(Transaction, CreateSyntheticRequest);
    Fail('The second append failure must propagate.');
  except
    on E: EInjectedMarriageFailure do
      AssertEquals('Injected append failure 2.', E.Message);
  end;

  AssertEquals(1, TransactionObject.RollbackCount);
  AssertEquals(0, TransactionObject.PendingCount);
  AssertEquals(0, TransactionObject.CommittedCount);
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestCommitFailureRollsBackAndPropagates;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  TransactionObject.FailCommit := True;
  Transaction := TransactionObject;
  try
    WriteMarriagePairAtomically(Transaction, CreateSyntheticRequest);
    Fail('The commit failure must propagate.');
  except
    on E: EInjectedMarriageFailure do
      AssertEquals('Injected commit failure.', E.Message);
  end;

  AssertEquals(1, TransactionObject.RollbackCount);
  AssertEquals(0, TransactionObject.PendingCount);
  AssertEquals(0, TransactionObject.CommittedCount);
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestRollbackFailureReportsBothFailures;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  TransactionObject.FailAppendAt := 2;
  TransactionObject.FailRollback := True;
  Transaction := TransactionObject;
  try
    WriteMarriagePairAtomically(Transaction, CreateSyntheticRequest);
    Fail('A failed rollback must be reported explicitly.');
  except
    on E: EMarriagePairRollbackFailure do
    begin
      AssertTrue(Pos('Injected append failure 2.', E.Message) > 0);
      AssertTrue(Pos('Injected rollback failure.', E.Message) > 0);
    end;
  end;
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestRejectsSelfMarriageBeforeStartingTransaction;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
  Request: TMarriagePairRequest;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  Transaction := TransactionObject;
  Request := CreateMarriagePairRequest(101, 202, CreateSyntheticDetails);
  Request.PartnerNumber := Request.PersonNumber;
  try
    WriteMarriagePairAtomically(Transaction, Request);
    Fail('Self-marriage must be rejected before opening a transaction.');
  except
    on E: EMarriagePairRequestInvalid do
      AssertTrue(Pos('cannot be connected to themselves', E.Message) > 0);
  end;
  AssertEquals(0, TransactionObject.BeginCount);
  AssertEquals(0, TransactionObject.AppendCount);
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestRejectsNonPositivePersonNumber;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
  Request: TMarriagePairRequest;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  Transaction := TransactionObject;
  Request := CreateSyntheticRequest;
  Request.PersonNumber := 0;
  try
    WriteMarriagePairAtomically(Transaction, Request);
    Fail('A non-positive person number must be rejected.');
  except
    on E: EMarriagePairRequestInvalid do
      AssertTrue(E.Message <> '');
  end;
  AssertEquals(0, TransactionObject.BeginCount);
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestBeginFailurePropagatesWithoutRollback;
var
  TransactionObject: TSyntheticMarriageTransaction;
  Transaction: IMarriagePairTransaction;
begin
  TransactionObject := TSyntheticMarriageTransaction.Create;
  TransactionObject.FailBegin := True;
  Transaction := TransactionObject;
  try
    WriteMarriagePairAtomically(Transaction, CreateSyntheticRequest);
    Fail('A begin failure must propagate.');
  except
    on E: EInjectedMarriageFailure do
      AssertEquals('Injected begin failure.', E.Message);
  end;
  AssertEquals(1, TransactionObject.BeginCount);
  AssertEquals(0, TransactionObject.RollbackCount);
  Transaction := nil;
end;

procedure TTestAHW52MarriagePairTransactionContract.
  TestRejectsMissingTransaction;
begin
  try
    WriteMarriagePairAtomically(nil, CreateSyntheticRequest);
    Fail('A missing transaction must not look like a successful write.');
  except
    on E: EArgumentNilException do
      AssertTrue(E.Message <> '');
  end;
end;

initialization
  RegisterTest(TTestAHW52MarriagePairTransactionContract);

end.
