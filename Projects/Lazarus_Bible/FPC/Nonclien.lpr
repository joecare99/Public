program Nonclien;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  frm_NonClientMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Nonclient Area Message Handling';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
