program Runme;

uses
  Forms,
  Frm_RunMeTEST in '..\source\README\Frm_RunMeTEST.PAS' {TestForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Runme - Demo';
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
