program Addpage;

uses
  Forms,
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.pas' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
  Application.Run;
end.
