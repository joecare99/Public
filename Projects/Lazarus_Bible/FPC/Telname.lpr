program Telname;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_TelnameMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Telname';
  Application.CreateForm(TfrmTelnameMain, frmTelnameMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmTelnameMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmTelnameMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
