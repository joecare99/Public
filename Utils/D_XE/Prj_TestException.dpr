program Prj_TestException;

uses
  Forms,
  Frm_TstException in '..\source\Frm_TstException.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
