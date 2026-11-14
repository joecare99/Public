program Actions;

uses
  Forms,
  Frm_ActionsMain in '..\Actions\Frm_ActionsMain.pas' {Form1};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
