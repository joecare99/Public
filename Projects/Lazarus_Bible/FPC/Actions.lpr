program Actions;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  DefaultTranslator,
  Frm_ActionsMain;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  Application.Run;
end.
