program Actions;

uses
  Forms,
  Frm_ActionsMain in '..\source\Actions\Frm_ActionsMain.pas' {Form1};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  Application.Run;
end.
