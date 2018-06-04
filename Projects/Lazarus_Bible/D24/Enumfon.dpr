program Enumfon; 
uses 
  Forms, 
  Frm_EnumFonMAIN in '..\Source\ENUMFON\Frm_EnumFonMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Enumfon'; 
  Application.CreateForm(TfrmEnumFontsMain, frmEnumFontsMain);
  Application.Run; 
end. 
