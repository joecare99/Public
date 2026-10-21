program Bitview;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_BitViewMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Bitview';
  Application.CreateForm(TfrmBitmapViewerMain, frmBitmapViewerMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmBitmapViewerMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmBitmapViewerMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
