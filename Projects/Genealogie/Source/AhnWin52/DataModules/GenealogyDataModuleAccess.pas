unit GenealogyDataModuleAccess;

{$mode objfpc}{$H+}

interface

uses
  DB, SysUtils;

type
  EDataModuleInterfaceUnavailable = class(Exception);
  EUnsupportedGenealogyDataIndex = class(Exception);
  EDataModuleTransactionUnavailable = class(Exception);
  EDataModuleWriteUnavailable = class(Exception);
  EDataModuleWriteState = class(EDataModuleWriteUnavailable);

  TMarriageDetails = record
    Htag: string;
    Hmonat: string;
    Hjahr: string;
    Hort: string;
    Trauz: string;
    Satag: string;
    Samonat: string;
    Sajahr: string;
    Saort: string;
    Satrauz: string;
    Verbind: string;
    Schtag: string;
    Schmonat: string;
    Schjahr: string;
    Schort: string;
    Hqu: string;
    Saqu: string;
    Schqu: string;
  end;

  { Exposes only members used by verified, migrated genealogy consumers. }
  IGenealogyDataModule = interface(IInterface)
    ['{E0F51AF0-7299-4B0B-911C-21642AC8F1A0}']
    { Begin starts a transaction if the provider has not already started one. }
    procedure BeginTransaction;
    procedure CommitTransaction;
    procedure RollbackTransaction;
    procedure AppendMarriageRecord(const PersonNumber, PartnerNumber: Integer;
      const Details: TMarriageDetails);
    function GetTable1: TDataSet;
    function GetTable3: TDataSet;
    function GetTable1Nummer: TField;
    function GetTable1Vater: TField;
    function GetTable1Mutter: TField;
    function GetTable1Name: TField;
    function GetTable1Vornamen: TField;
    function GetTable1Religion: TField;
    function GetTable5: TDataSet;
    function GetTable5Numr: TField;
    function GetTable5Epnum: TField;
    function GetTable17: TDataSet;
    function GetTable18: TDataSet;
    function GetTable7: TDataSet;
    function GetTable8: TDataSet;
    function GetTable9: TDataSet;
    function GetTable13: TDataSet;
    function GetTable13Ort: TField;
    procedure SetTable13Index(const IndexName: string);
    property Table1: TDataSet read GetTable1;
    property Table3: TDataSet read GetTable3;
    property Table1Nummer: TField read GetTable1Nummer;
    property Table1Vater: TField read GetTable1Vater;
    property Table1Mutter: TField read GetTable1Mutter;
    property Table1Name: TField read GetTable1Name;
    property Table1Vornamen: TField read GetTable1Vornamen;
    property Table1Religion: TField read GetTable1Religion;
    property Table5: TDataSet read GetTable5;
    property Table5Numr: TField read GetTable5Numr;
    property Table5Epnum: TField read GetTable5Epnum;
    property Table17: TDataSet read GetTable17;
    property Table18: TDataSet read GetTable18;
    property Table7: TDataSet read GetTable7;
    property Table8: TDataSet read GetTable8;
    property Table9: TDataSet read GetTable9;
    property Table13: TDataSet read GetTable13;
    property Table13Ort: TField read GetTable13Ort;
  end;

  { Non-genealogy members are added here after their temporary status is verified. }
  ITemporaryDataModule = interface(IInterface)
    ['{2C2A992E-8787-4DE9-A7B8-59225E6EFB7C}']
  end;

var
  GenealogyDataModule: IGenealogyDataModule;
  TemporaryDataModule: ITemporaryDataModule;

function RequireGenealogyDataModule: IGenealogyDataModule;
function RequireTemporaryDataModule: ITemporaryDataModule;

implementation

function RequireGenealogyDataModule: IGenealogyDataModule;
begin
  Result := GenealogyDataModule;
  if Result = nil then
    raise EDataModuleInterfaceUnavailable.Create(
      'The genealogy data module interface has not been initialized.');
end;

function RequireTemporaryDataModule: ITemporaryDataModule;
begin
  Result := TemporaryDataModule;
  if Result = nil then
    raise EDataModuleInterfaceUnavailable.Create(
      'The temporary data module interface has not been initialized.');
end;

end.
