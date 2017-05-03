program Bitview; 
uses 
  Forms, 
  Frm_BitViewMAIN in '..\Source\BITVIEW\Frm_BitViewMAIN.PAS' {frmBitmapViewerMain}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Bitview'; 
  Application.CreateForm(TfrmBitmapViewerMain, frmBitmapViewerMain); 
  Application.Run; 
end. 
