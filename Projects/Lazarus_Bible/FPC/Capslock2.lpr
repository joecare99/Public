program Capslock2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_Capslock2MAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Capslock2';
  Application.CreateForm(TfrmCapsLock2Main, frmCapsLock2Main);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCapsLock2Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCapsLock2Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
