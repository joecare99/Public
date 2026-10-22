program Runme;

uses
  Forms,
  Test in 'TEST.PAS' {TestForm};

{$R *.RES}

begin
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
