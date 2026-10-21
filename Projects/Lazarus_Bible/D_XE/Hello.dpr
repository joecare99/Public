program Hello;

uses
  Forms,
  frm_HelloMAIN in '..\view\Frm_HelloMAIN.pas' {Form1},
  HelloViewModel in '..\viewmodel\HelloViewModel.pas';

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Hello';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

