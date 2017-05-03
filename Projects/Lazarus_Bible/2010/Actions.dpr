program Actions; 

uses
  Forms,
  Frm_ActionsMain in '..\Source\Actions\Frm_ActionsMain.pas' {Form1};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize; 
  Application.Title := 'Demo: Actions'; 
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  Application.Run; 
end. 
