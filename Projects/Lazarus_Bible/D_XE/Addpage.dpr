program Addpage;

uses
  Forms,
  Frm_AddpageMAIN in '..\source\ADDPAGE\Frm_AddpageMAIN.PAS' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
  Application.Run;
end.
