unit FokoListReportCompatibilityError;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  /// Identifies a FOKO report action that has not yet been migrated.
  EFokoListReportOperationUnsupported = class(Exception)
  private
    FOperation: string;
  public
    /// Creates an exception naming the unavailable report operation.
    constructor Create(const AOperation: string);
    /// The exact unavailable report operation.
    property Operation: string read FOperation;
  end;

  /// Signals that LazReport did not produce a prepared FOKO report.
  EFokoListReportPreparationFailed = class(Exception);

implementation

constructor EFokoListReportOperationUnsupported.Create(
  const AOperation: string);
begin
  FOperation := AOperation;
  inherited CreateFmt('FOKO LazReport operation "%s" is not implemented.',
    [AOperation]);
end;

end.
