unit Unit18GlobalDataSetExportSource;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Unit18ExportWorkflow;

type
  TUnit18GlobalDataSetExportSourceFactory = class(TInterfacedObject,
    IUnit18ExportSourceFactory)
  public
    function CreateSource: IUnit18ExportSource;
  end;

implementation

uses
  Unit18DataSetExportSource, GenealogyDataModule;

function TUnit18GlobalDataSetExportSourceFactory.CreateSource:
  IUnit18ExportSource;
begin
  Result := TUnit18DataSetExportSource.Create(DataModule2.Table16);
end;

end.
