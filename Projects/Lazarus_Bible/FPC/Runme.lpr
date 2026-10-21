program Runme;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  DefaultTranslator,
  Frm_RunMeTEST;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Runme - Demo';
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
