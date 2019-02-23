program Addpage;

uses
  Forms,
  Frm_AddpageMAIN in '..\source\ADDPAGE\Frm_AddpageMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Addpage';
  Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
  Application.Run;
end.
