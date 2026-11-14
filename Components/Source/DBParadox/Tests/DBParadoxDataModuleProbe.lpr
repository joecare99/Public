program DBParadoxDataModuleProbe;

{$mode objfpc}{$H+}

uses
  Interfaces, Classes, SysUtils,
  Forms, SQLDB, DBParadoxConnection;

type
  TDBParadoxProbeDataModule = class(TDataModule)
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TDBParadoxProbeDataModule.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
end;

procedure Require(Condition: Boolean; const MessageText: string);
begin
  if not Condition then
    raise Exception.Create(MessageText);
end;

var
  SourceModule, LoadedModule: TDBParadoxProbeDataModule;
  SourceConnection, LoadedConnection: TDBParadoxConnection;
  SourceTransaction, LoadedTransaction: TSQLTransaction;
  SourceQuery, LoadedQuery: TSQLQuery;
  Stream: TMemoryStream;
begin
  try
    Application.Initialize;
    RegisterClass(TDBParadoxProbeDataModule);
    RegisterClass(TDBParadoxConnection);
    RegisterClass(TSQLTransaction);
    RegisterClass(TSQLQuery);

    SourceModule := TDBParadoxProbeDataModule.Create(nil);
    Stream := TMemoryStream.Create;
    try
      SourceModule.Name := 'DBParadoxProbeDataModule';
      SourceConnection := TDBParadoxConnection.Create(SourceModule);
      SourceConnection.Name := 'ParadoxConnection';
      SourceConnection.DatabaseName := GetCurrentDir;

      SourceTransaction := TSQLTransaction.Create(SourceModule);
      SourceTransaction.Name := 'ParadoxTransaction';
      SourceTransaction.Database := SourceConnection;

      SourceQuery := TSQLQuery.Create(SourceModule);
      SourceQuery.Name := 'ParadoxQuery';
      SourceQuery.Database := SourceConnection;
      SourceQuery.Transaction := SourceTransaction;
      SourceQuery.SQL.Text := 'SELECT ID FROM Synthetic';

      Stream.WriteComponent(SourceModule);
      Stream.Position := 0;
      LoadedModule := TDBParadoxProbeDataModule(Stream.ReadComponent(nil));
      try
        LoadedConnection := TDBParadoxConnection(
          LoadedModule.FindComponent('ParadoxConnection'));
        LoadedTransaction := TSQLTransaction(
          LoadedModule.FindComponent('ParadoxTransaction'));
        LoadedQuery := TSQLQuery(
          LoadedModule.FindComponent('ParadoxQuery'));
        Require(Assigned(LoadedConnection),
          'The streamed DataModule lost its DBParadox connection.');
        Require(Assigned(LoadedTransaction),
          'The streamed DataModule lost its SQLDB transaction.');
        Require(Assigned(LoadedQuery),
          'The streamed DataModule lost its SQLDB query.');
        Require(LoadedTransaction.Database = LoadedConnection,
          'The streamed transaction is not attached to the DBParadox connection.');
        Require(LoadedQuery.Database = LoadedConnection,
          'The streamed SQLDB query is not attached to the DBParadox connection.');
        Require(LoadedQuery.Transaction = LoadedTransaction,
          'The streamed SQLDB query is not attached to the SQLDB transaction.');
        Require(TrimRight(LoadedQuery.SQL.Text) = 'SELECT ID FROM Synthetic',
          'The streamed SQLDB query text did not round-trip.');
        Require(not LoadedConnection.Connected and
          not LoadedTransaction.Active and not LoadedQuery.Active,
          'The streamed DataModule unexpectedly opened database resources.');
      finally
        LoadedModule.Free;
      end;
    finally
      Stream.Free;
      SourceModule.Free;
    end;
    WriteLn('RESULT=DATAMODULE_STREAM_ROUNDTRIP_PASS');
  except
    on E: Exception do
    begin
      WriteLn(ErrOutput, 'ERROR=', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
