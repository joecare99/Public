program YesNoTest;
uses
  Forms,
  Frm_YesNoMAIN in '..\source\YESNO\Frm_YesNoMAIN.pas' {frmYesNoMain},
  Frm_YesNo in '..\source\YESNO\Frm_YesNo.pas';

{$R *.RES}
{$E EXE} 
begin 
  Application.Initialize; 
  Application.title:='Demo: YesNoTest';
  Application.CreateForm(TfrmYesNoMain, frmYesNoMain);
  Application.CreateForm(TfrmYesNoDlg, frmYesNoDlg);
  Application.Run;
end.
