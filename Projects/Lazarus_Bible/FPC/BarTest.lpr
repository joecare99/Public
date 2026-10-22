program BarTest;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_BartestMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: BarTest';
  Application.CreateForm(TfrmBarChartMain, frmBarChartMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmBarChartMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmBarChartMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
