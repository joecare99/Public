unit DBTables;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SQLDB, DBTablesCompatErrors;

type
  /// Compile-time replacement for the legacy BDE query component.
  TQuery = class(TSQLQuery)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  raise EDBTablesCompatibilityUnsupported.Create('TQuery.Create');
end;

initialization
  RegisterClass(TQuery);

end.
