unit Unit18DataSetExportSource;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  DB, SysUtils, Unit18ExportWorkflow;

type
  TUnit18DataSetExportSource = class(TInterfacedObject,
    IUnit18ExportSource)
  private
    FDataSet: TDataSet;
  public
    constructor Create(DataSet: TDataSet);
    procedure First;
    function EOF: Boolean;
    function CurrentRow: TUnit18ExportRow;
    procedure Next;
  end;

implementation

constructor TUnit18DataSetExportSource.Create(DataSet: TDataSet);
begin
  inherited Create;
  if DataSet = nil then
    raise EUnit18ExportArgumentError.Create('DataSet must not be nil.');
  { The dataset is borrowed; its owner keeps it alive for the workflow. }
  FDataSet := DataSet;
end;

procedure TUnit18DataSetExportSource.First;
begin
  FDataSet.First;
end;

function TUnit18DataSetExportSource.EOF: Boolean;
begin
  Result := FDataSet.EOF;
end;

function TUnit18DataSetExportSource.CurrentRow: TUnit18ExportRow;
begin
  Result.Number := FDataSet.FieldByName('Nummer').AsInteger;
  Result.Name := FDataSet.FieldByName('Name').AsString;
  Result.BirthDay := FDataSet.FieldByName('Gebtag').AsString;
  Result.BirthMonth := FDataSet.FieldByName('Gebmonat').AsString;
  Result.BirthYear := FDataSet.FieldByName('Gebjahr').AsString;
  Result.BirthPlace := FDataSet.FieldByName('Gebort').AsString;
  Result.DeathDay := FDataSet.FieldByName('Sttag').AsString;
  Result.DeathMonth := FDataSet.FieldByName('Stmonat').AsString;
  Result.DeathYear := FDataSet.FieldByName('Stjahr').AsString;
  Result.DeathPlace := FDataSet.FieldByName('Stort').AsString;
  Result.HDay := FDataSet.FieldByName('Htag').AsString;
  Result.HMonth := FDataSet.FieldByName('Hmonat').AsString;
  Result.HYear := FDataSet.FieldByName('Hjahr').AsString;
  Result.HPlace := FDataSet.FieldByName('Hort').AsString;
  Result.HName := FDataSet.FieldByName('Hname').AsString;
end;

procedure TUnit18DataSetExportSource.Next;
begin
  FDataSet.Next;
end;

end.
