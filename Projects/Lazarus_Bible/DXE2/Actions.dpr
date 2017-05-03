program Actions;

uses
  Forms,
  Frm_ActionsMain in '..\source\Actions\Frm_ActionsMain.pas' {Form1};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
