program Capslock;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CapslockMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Capslock';
  Application.CreateForm(TfrmCapsLockMain, frmCapsLockMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCapsLockMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCapsLockMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
