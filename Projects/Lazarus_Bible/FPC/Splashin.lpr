program Splashin;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_SPLASH,
  Frm_SplashinMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Splashin - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
