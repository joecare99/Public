program Spinbutt;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_SpinButtonMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'SpinButton - Demo';
  Application.CreateForm(TfrmSpinButtonMain, frmSpinButtonMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmSpinButtonMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmSpinButtonMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
