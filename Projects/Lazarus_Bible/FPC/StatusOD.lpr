program StatusOD;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_StatusODMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'StatusOD - Demo';
  Application.CreateForm(TfrmStatusODMain, frmStatusODMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmStatusODMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmStatusODMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
