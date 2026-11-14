unit MarriagePairDataModuleAdapter;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  GenealogyDataModuleAccess, MarriagePairTransactionContract;

function CreateMarriagePairDataModuleAdapter(
  const DataModule: IGenealogyDataModule): IMarriagePairTransaction;

implementation

uses
  SysUtils;

type
  TMarriagePairDataModuleAdapter = class(TInterfacedObject,
    IMarriagePairTransaction)
  private
    FDataModule: IGenealogyDataModule;
  public
    constructor Create(const DataModule: IGenealogyDataModule);
    procedure BeginTransaction;
    procedure AppendMarriageRecord(const PersonNumber, PartnerNumber: Integer;
      const Details: TMarriageDetails);
    procedure CommitTransaction;
    procedure RollbackTransaction;
  end;

constructor TMarriagePairDataModuleAdapter.Create(
  const DataModule: IGenealogyDataModule);
begin
  inherited Create;
  if DataModule = nil then
    raise EDataModuleInterfaceUnavailable.Create(
      'The genealogy data module interface is not initialized.');
  FDataModule := DataModule;
end;

procedure TMarriagePairDataModuleAdapter.BeginTransaction;
begin
  FDataModule.BeginTransaction;
end;

procedure TMarriagePairDataModuleAdapter.AppendMarriageRecord(
  const PersonNumber, PartnerNumber: Integer; const Details: TMarriageDetails);
begin
  FDataModule.AppendMarriageRecord(PersonNumber, PartnerNumber, Details);
end;

procedure TMarriagePairDataModuleAdapter.CommitTransaction;
begin
  FDataModule.CommitTransaction;
end;

procedure TMarriagePairDataModuleAdapter.RollbackTransaction;
begin
  FDataModule.RollbackTransaction;
end;

function CreateMarriagePairDataModuleAdapter(
  const DataModule: IGenealogyDataModule): IMarriagePairTransaction;
begin
  Result := TMarriagePairDataModuleAdapter.Create(DataModule);
end;

end.
