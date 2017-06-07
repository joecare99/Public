program Prj_GetKeyCode;

uses
  Forms,
  Tst_KeyCode in '..\source\Tst_KeyCode.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
