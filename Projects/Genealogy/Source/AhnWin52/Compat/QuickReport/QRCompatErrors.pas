unit QRCompatErrors;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  /// Signals that an operation requires the unavailable QuickReport engine.
  EQuickReportCompatibilityUnsupported = class(Exception)
  private
    FOperation: string;
  public
    /// Creates a failure that identifies the unavailable QuickReport operation.
    constructor Create(const Operation: string);
    /// The operation that cannot be performed by the compile-only layer.
    property Operation: string read FOperation;
  end;

  /// Base type for QuickReport design-time contract declarations.
  TQuickReportCompatComponent = class(TComponent)
  public
    /// Refuses construction so a dummy component cannot be mistaken for a report engine.
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor EQuickReportCompatibilityUnsupported.Create(
  const Operation: string);
begin
  FOperation := Operation;
  inherited CreateFmt(
    'QuickReport compatibility layer cannot perform "%s"; migrate this path to LazReport.',
    [Operation]);
end;

constructor TQuickReportCompatComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  raise EQuickReportCompatibilityUnsupported.Create(ClassName + '.Create');
end;

end.
