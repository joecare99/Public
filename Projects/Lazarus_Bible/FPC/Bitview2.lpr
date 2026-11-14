program Bitview2;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_BitView2MAIN;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Bitview2';
  Application.CreateForm(TfrmBitmapViewer2Main, frmBitmapViewer2Main);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmBitmapViewer2Main.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmBitmapViewer2Main, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
