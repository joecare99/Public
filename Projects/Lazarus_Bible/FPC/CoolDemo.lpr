program CoolDemo;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  DefaultTranslator,
  frm_CooldemoMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: CoolDemo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
