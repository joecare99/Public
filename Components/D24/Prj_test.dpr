program Prj_test;

uses
  Forms,
  Frm_test in '..\Test\Frm_test.pas' {Form1},
  Unt_FileProcs in '..\Unt_FileProcs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
