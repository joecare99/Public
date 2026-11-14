unit MainFormExitBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  IMainFormExitActions = interface
    ['{A3B281ED-4C5D-4E81-9EBD-CAD2BA54C28D}']
    procedure DisablePrivacyMode;
    procedure ActivateDataPage;
    procedure CloseMainForm;
  end;

/// Executes the main-form exit-menu actions in their recovered order.
procedure ExecuteMainFormExit(const Actions: IMainFormExitActions);

implementation

procedure ExecuteMainFormExit(const Actions: IMainFormExitActions);
begin
  if Actions = nil then
    raise EArgumentNilException.Create('Actions');

  Actions.DisablePrivacyMode;
  Actions.ActivateDataPage;
  Actions.CloseMainForm;
end;

end.
