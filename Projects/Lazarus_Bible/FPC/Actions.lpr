program Actions;

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
  Frm_ActionsMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    FrmActionsMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(FrmActionsMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
