program Sqlplay;

uses
  Forms,
  Frm_SqlplayMAIN in '..\SQLPLAY\Frm_SqlplayMAIN.pas' {MainForm},
  Frm_SQLOPENDB in '..\SQLPLAY\Frm_SQLOPENDB.pas' {OpenForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sqlplay - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOpenForm, OpenForm);
  Application.Run;
end.
