program Objlist; 
uses 
  Forms, 
  Frm_ObjListMAIN in '..\source\OBJLIST\Frm_ObjListMAIN.pas' {MainForm}; 
{$R *.RES} 
begin 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
