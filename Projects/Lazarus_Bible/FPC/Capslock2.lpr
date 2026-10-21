program Capslock2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  Frm_Capslock2MAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Capslock2';
  Application.CreateForm(TfrmCapsLock2Main, frmCapsLock2Main);
  Application.Run;
end.
