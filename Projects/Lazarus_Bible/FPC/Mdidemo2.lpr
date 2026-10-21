program Mdidemo2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  CHILD2;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'MDI Demonstration 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
