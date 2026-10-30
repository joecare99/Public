unit GregorianCalendarPrintCompatibilityError;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses
  SysUtils;

type
  /// Identifies the unavailable native form-printing operation.
  EGregorianCalendarPrintUnsupported = class(Exception)
  private
    FOperation: string;
  public
    constructor Create(const AOperation: string);
    property Operation: string read FOperation;
  end;

implementation

constructor EGregorianCalendarPrintUnsupported.Create(
  const AOperation: string);
begin
  FOperation := AOperation;
  inherited CreateFmt('Gregorian calendar operation "%s" is not implemented on this platform.',
    [AOperation]);
end;

end.
