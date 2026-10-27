program CoolDemo;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  DefaultTranslator,
  frm_CooldemoMain;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: CoolDemo';
  Application.CreateForm(TfrmCoolDemoMain, frmCoolDemoMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCoolDemoMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCoolDemoMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
