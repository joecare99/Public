program Fontsamp; 
uses 
  Forms, 
  frm_fontsampMAIN in '..\source\FontSamp\frm_fontsampMAIN.pas' {MainForm}, 
  Frm_fontSampABOUT in '..\source\FontSamp\Frm_fontSampABOUT.pas' {AboutForm}, 
  PREVIEW in '..\source\FontSamp\PREVIEW.pas' {PreviewForm}, 
  DRAWPAGE in '..\source\FontSamp\DRAWPAGE.pas'; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Fontsamp'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.CreateForm(TPreviewForm, PreviewForm); 
  Application.Run; 
end. 
