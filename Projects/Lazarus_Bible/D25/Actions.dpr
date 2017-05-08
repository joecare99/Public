program Actions;

uses
  Forms,
  Frm_ActionsMain in '..\source\Actions\Frm_ActionsMain.pas' {FrmActionsMain};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  Application.Run;
end.
