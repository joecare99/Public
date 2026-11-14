program Addpage; 
uses 
  Forms, 
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
