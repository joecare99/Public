program Bitview2; 
uses 
  Forms, 
  Frm_BitView2MAIN in '..\source\Bitview2\Frm_BitView2MAIN.pas' {frmBitmapViewer2Main}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Bitview2'; 
  Application.CreateForm(TfrmBitmapViewer2Main, frmBitmapViewer2Main); 
  Application.Run; 
end. 
