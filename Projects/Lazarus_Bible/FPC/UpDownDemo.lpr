program UpDownDemo;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_UpDownDemoMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: UpDownDemo';
  Application.CreateForm(TfrmUpDownDemoMain, frmUpDownDemoMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmUpDownDemoMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmUpDownDemoMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
