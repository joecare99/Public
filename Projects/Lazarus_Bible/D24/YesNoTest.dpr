program YesNoTest;
uses
  Forms,
  Frm_YesNoMAIN in '..\Source\YESNO\Frm_YesNoMAIN.PAS' {frmYesNoMain},
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
