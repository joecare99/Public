program Addpage; 
uses 
  Forms, 
  Frm_AddpageMAIN in '..\Source\ADDPAGE\Frm_AddpageMAIN.PAS' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
