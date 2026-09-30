program AHW52_Form6;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, GregorianCalendar, GregorianCalendarViewModel
  { you can add units after this };

{$R *.res}

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TGregorianCalendarForm, GregorianCalendarForm);
  GregorianCalendarForm.ViewModel := TGregorianCalendarViewModel.Create;
  Application.Run;
end.
