program Sketch; 
uses 
  Forms, 
  Frm_SketchMAIN in '..\Source\SKETCH\Frm_SketchMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Sketch - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
