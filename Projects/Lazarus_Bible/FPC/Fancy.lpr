program Fancy;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_FancyMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Fancy';
  Application.CreateForm(TfrmFancyMain, frmFancyMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmFancyMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmFancyMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
