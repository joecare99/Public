program Sysmenu;

uses
  Forms,
  Frm_SysmenuMain in '..\source\SysMenu\Frm_SysmenuMain.pas' {Form1};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sysmenu - Demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
