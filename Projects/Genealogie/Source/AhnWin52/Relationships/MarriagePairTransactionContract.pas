unit MarriagePairTransactionContract;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  GenealogyDataModuleAccess, SysUtils;

type
  TMarriagePairRequest = record
    PersonNumber: Integer;
    PartnerNumber: Integer;
    Details: TMarriageDetails;
  end;

  IMarriagePairTransaction = interface
    ['{2B5BDF4E-49A4-4582-90B9-3B390FBC95EF}']
    procedure BeginTransaction;
    procedure AppendMarriageRecord(const PersonNumber, PartnerNumber: Integer;
      const Details: TMarriageDetails);
    procedure CommitTransaction;
    procedure RollbackTransaction;
  end;

  EMarriagePairError = class(Exception);
  EMarriagePairRequestInvalid = class(EMarriagePairError);
  EMarriagePairRollbackFailure = class(EMarriagePairError);

function CreateMarriagePairRequest(const PersonNumber, PartnerNumber: Integer;
  const Details: TMarriageDetails): TMarriagePairRequest;
procedure ValidateMarriagePairRequest(const Request: TMarriagePairRequest);
procedure WriteMarriagePairAtomically(const Transaction: IMarriagePairTransaction;
  const Request: TMarriagePairRequest);

implementation

function CreateMarriagePairRequest(const PersonNumber, PartnerNumber: Integer;
  const Details: TMarriageDetails): TMarriagePairRequest;
begin
  Result.PersonNumber := PersonNumber;
  Result.PartnerNumber := PartnerNumber;
  Result.Details := Details;
  ValidateMarriagePairRequest(Result);
end;

procedure ValidateMarriagePairRequest(const Request: TMarriagePairRequest);
begin
  if Request.PersonNumber <= 0 then
    raise EMarriagePairRequestInvalid.Create(
      'A marriage requires a positive person number.');
  if Request.PartnerNumber <= 0 then
    raise EMarriagePairRequestInvalid.Create(
      'A marriage requires a positive partner number.');
  if Request.PersonNumber = Request.PartnerNumber then
    raise EMarriagePairRequestInvalid.Create(
      'A person cannot be connected to themselves.');
end;

procedure WriteMarriagePairAtomically(
  const Transaction: IMarriagePairTransaction;
  const Request: TMarriagePairRequest);
var
  OriginalFailure: string;
begin
  ValidateMarriagePairRequest(Request);
  if Transaction = nil then
    raise EArgumentNilException.Create('Transaction');

  Transaction.BeginTransaction;
  try
    Transaction.AppendMarriageRecord(Request.PersonNumber,
      Request.PartnerNumber, Request.Details);
    Transaction.AppendMarriageRecord(Request.PartnerNumber,
      Request.PersonNumber, Request.Details);
    Transaction.CommitTransaction;
  except
    on E: Exception do
    begin
      OriginalFailure := E.ClassName + ': ' + E.Message;
      try
        Transaction.RollbackTransaction;
      except
        on RollbackError: Exception do
          raise EMarriagePairRollbackFailure.CreateFmt(
            'Marriage-pair write failed (%s); rollback also failed (%s).',
            [OriginalFailure,
             RollbackError.ClassName + ': ' + RollbackError.Message]);
      end;
      raise;
    end;
  end;
end;

end.
