program Addpage;

uses
  Forms,
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.PAS' {frmAddPageMain};

{$E EXE}
{$R *.RES}

begin
  Application.Title := 'Demo: Add Page';
  Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
  Application.Run;
end.
