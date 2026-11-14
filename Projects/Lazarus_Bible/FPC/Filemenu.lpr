program Filemenu;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_FileMenuMAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Filemenu';
  Application.CreateForm(TfrmFileMenuMain, frmFileMenuMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmFileMenuMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmFileMenuMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
