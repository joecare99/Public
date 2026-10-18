unit Unit16ExportCompatibilityError;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  /// Identifies a Unit16 export operation that has not yet been reconstructed.
  EUnit16ExportOperationUnsupported = class(Exception)
  private
    FOperation: string;
  public
    constructor Create(const AOperation: string);
    property Operation: string read FOperation;
  end;

implementation

constructor EUnit16ExportOperationUnsupported.Create(
  const AOperation: string);
begin
  FOperation := AOperation;
  inherited CreateFmt('Unit16 export operation "%s" is not implemented.',
    [AOperation]);
end;

end.
