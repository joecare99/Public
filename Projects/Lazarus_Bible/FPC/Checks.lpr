program Checks;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_ChecksMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Checks';
  Application.CreateForm(TfrmChecksMain, frmChecksMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmChecksMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmChecksMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
