program Bartest1;

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_BartestMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Bartest1';
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
