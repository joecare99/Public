program Options;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_OptionsMain,
  Inidata;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Options - Demo';
  Application.CreateForm(TfrmOptionsMain, frmOptionsMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmOptionsMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmOptionsMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
