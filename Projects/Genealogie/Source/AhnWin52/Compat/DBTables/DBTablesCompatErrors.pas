unit DBTablesCompatErrors;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  EDBTablesCompatibilityUnsupported = class(Exception)
  private
    FOperation: string;
  public
    constructor Create(const Operation: string);
    property Operation: string read FOperation;
  end;

implementation

constructor EDBTablesCompatibilityUnsupported.Create(
  const Operation: string);
begin
  FOperation := Operation;
  inherited CreateFmt(
    'DBTables compatibility stub cannot perform "%s"; migrate this path from BDE.',
    [Operation]);
end;

end.
