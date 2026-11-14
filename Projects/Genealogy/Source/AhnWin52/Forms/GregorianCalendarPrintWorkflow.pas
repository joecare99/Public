unit GregorianCalendarPrintWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses
  Classes,
  Controls,
  Forms;

/// Applies the recovered control visibility/layout sequence around printing.
/// The action is injected so the visibility transition can be tested without printing.
procedure RunGregorianCalendarPrintWorkflow(CalendarForm: TCustomForm;
  FollowYearButton: TControl; PreviousYearButton: TWinControl;
  OkButton, PrintButton: TControl; PrintAction: TNotifyEvent);

implementation

procedure RunGregorianCalendarPrintWorkflow(CalendarForm: TCustomForm;
  FollowYearButton: TControl; PreviousYearButton: TWinControl;
  OkButton, PrintButton: TControl; PrintAction: TNotifyEvent);
begin
  FollowYearButton.Hide;
  PreviousYearButton.Realign;
  OkButton.Hide;
  PrintButton.Hide;
  PrintAction(CalendarForm);
  FollowYearButton.Show;
  PreviousYearButton.Show;
  OkButton.Show;
  PrintButton.Show;
end;

end.
