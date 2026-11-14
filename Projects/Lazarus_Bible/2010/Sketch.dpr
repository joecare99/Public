program Sketch; 
uses 
  Forms, 
  Frm_SketchMAIN in '..\source\Sketch\Frm_SketchMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Sketch - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
