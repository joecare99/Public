program Cclient;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_CLIMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Cclient';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
