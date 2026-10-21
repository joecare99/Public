program StaticDemo;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_StaticDemoMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'StaticDemo - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
