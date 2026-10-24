program Status;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_StatusMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Status - Demo';
  Application.CreateForm(TfrmStatusMain, frmStatusMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmStatusMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmStatusMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
