unit DBTables;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SQLDB, Cmp_SQLTable, DBTablesCompatErrors;

type
  /// Non-I/O compatibility surface for legacy BDE query components.
  TQuery = class(TSQLQuery)
  protected
    procedure OpenCursor(InfoQuery: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecSQL; override;
    procedure Prepare; override;
  end;

  /// BDE-only methods exposed on the SQLDB table class fail explicitly.
  TSQLTableBDECompatibilityHelper = class helper for TSQLTable
  public
    function FindKey(const KeyValues: array of const): Boolean;
    procedure EmptyTable;
  end;

implementation

constructor TQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQuery.OpenCursor(InfoQuery: Boolean);
begin
  RaiseDBTablesCompatibilityUnsupported('TQuery.OpenCursor');
end;

procedure TQuery.ExecSQL;
begin
  RaiseDBTablesCompatibilityUnsupported('TQuery.ExecSQL');
end;

procedure TQuery.Prepare;
begin
  RaiseDBTablesCompatibilityUnsupported('TQuery.Prepare');
end;

{$IFDEF FPC}
{$PUSH}
{$WARN 5033 OFF}
{$ENDIF}
function TSQLTableBDECompatibilityHelper.FindKey(
  const KeyValues: array of const): Boolean;
begin
  raise EDBTablesCompatibilityUnsupported.Create('TTable.FindKey');
end;
{$IFDEF FPC}
{$POP}
{$ENDIF}

procedure TSQLTableBDECompatibilityHelper.EmptyTable;
begin
  RaiseDBTablesCompatibilityUnsupported('TTable.EmptyTable');
end;

initialization
  RegisterClass(TQuery);

end.
