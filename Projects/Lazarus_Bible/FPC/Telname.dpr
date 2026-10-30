program Telname; 
uses 
  Forms, 
  Frm_TelnameMAIN in '..\source\TELNAME\Frm_TelnameMAIN.pas' {frmTelnameMain},
  TelnameViewModel in '..\source\TELNAME\viewmodel\TelnameViewModel.pas',
  TelnameModel in '..\source\TELNAME\model\TelnameModel.pas';
{$R *.RES}
{$E EXE}
begin
  Application.Initialize;
  Application.Title := 'Demo: Telname';
  Application.CreateForm(TfrmTelnameMain, frmTelnameMain);
  Application.Run;
end.
