program Listfont; 
uses 
  Forms, 
  Frm_ListFontMAIN in '..\Source\LISTFONT\Frm_ListFontMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
Application.Initialize; 
  Application.Title := 'Font-Lister'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
