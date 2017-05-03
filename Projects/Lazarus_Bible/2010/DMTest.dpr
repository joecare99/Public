program DMTest; 
uses 
  Forms, 
  Frm_DMTestMain in '..\Source\DMTest\Frm_DMTestMain.pas' {MainForm}, 
  Frm_Module1 in '..\Source\DMTest\Frm_Module1.pas' {DataModule1: TDataModule}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: DMTest'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TDataModule1, DataModule1); 
  Application.Run; 
end. 
