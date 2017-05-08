program PicDialogs; 
uses 
  Forms, 
  Frm_PicDialogsMain in '..\Source\PicDialogs\Frm_PicDialogsMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'PicDialogs - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
