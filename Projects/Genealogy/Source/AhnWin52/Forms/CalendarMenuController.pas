unit CalendarMenuController;

{$mode objfpc}{$H+}

interface

uses
  GregorianCalendar, FrenchRepublicanCalendarForm;

type
  TCalendarMenuAction = procedure of object;
  TCalendarMenuSaveAction = procedure(Sender: TObject) of object;
  TGregorianCalendarFactory = function: TGregorianCalendarForm of object;
  TGregorianCalendarAction =
    procedure(CalendarForm: TGregorianCalendarForm) of object;
  TFrenchCalendarFactory =
    function: TFrenchRepublicanCalendarForm of object;
  TFrenchCalendarAction =
    procedure(CalendarForm: TFrenchRepublicanCalendarForm) of object;

  { Bind the event sequence to its form adapter; callbacks are required. }
  TCalendarMenuActions = record
    ActivateEditTab: TCalendarMenuAction;
    SaveCurrentRecord: TCalendarMenuSaveAction;
    CreateGregorianForm: TGregorianCalendarFactory;
    ConfigureGregorianForm: TGregorianCalendarAction;
    ShowGregorianForm: TGregorianCalendarAction;
    DisposeGregorianForm: TGregorianCalendarAction;
    CreateFrenchForm: TFrenchCalendarFactory;
    AssignFrenchFormReference: TFrenchCalendarAction;
    ShowFrenchForm: TFrenchCalendarAction;
    ReleaseFrenchForm: TFrenchCalendarAction;
    ClearFrenchFormReference: TCalendarMenuAction;
  end;

{ Activates the edit tab, saves, shows the configured Gregorian form, then frees it. }
procedure ExecuteGregorianCalendarMenuAction(
  const Actions: TCalendarMenuActions; Sender: TObject);

{ Activates the edit tab, saves, then releases and clears Form7 in finally. }
procedure ExecuteFrenchCalendarMenuAction(
  const Actions: TCalendarMenuActions; Sender: TObject);

implementation

procedure ExecuteGregorianCalendarMenuAction(
  const Actions: TCalendarMenuActions; Sender: TObject);
var
  calendarForm: TGregorianCalendarForm;
begin
  Actions.ActivateEditTab;
  Actions.SaveCurrentRecord(Sender);
  calendarForm := Actions.CreateGregorianForm();
  try
    Actions.ConfigureGregorianForm(calendarForm);
    Actions.ShowGregorianForm(calendarForm);
  finally
    Actions.DisposeGregorianForm(calendarForm);
  end;
end;

procedure ExecuteFrenchCalendarMenuAction(
  const Actions: TCalendarMenuActions; Sender: TObject);
var
  calendarForm: TFrenchRepublicanCalendarForm;
begin
  Actions.ActivateEditTab;
  Actions.SaveCurrentRecord(Sender);
  calendarForm := Actions.CreateFrenchForm();
  Actions.AssignFrenchFormReference(calendarForm);
  try
    Actions.ShowFrenchForm(calendarForm);
  finally
    try
      Actions.ReleaseFrenchForm(calendarForm);
    finally
      Actions.ClearFrenchFormReference;
    end;
  end;
end;

end.
