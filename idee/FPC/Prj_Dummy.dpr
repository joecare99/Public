program Prj_Dummy;

uses
  Forms,
  frm_DummyMain in 'frm_DummyMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
