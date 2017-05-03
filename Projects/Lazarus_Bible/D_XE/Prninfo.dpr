program Prninfo;

uses
  Forms,
  Frm_PrnInfoMAIN in '..\source\PRNINFO\Frm_PrnInfoMAIN.PAS' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PrnInfo - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
