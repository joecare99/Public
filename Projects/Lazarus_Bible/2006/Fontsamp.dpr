program Fontsamp;

uses
  Forms,
  frm_fontsampMAIN in '..\FontSamp\frm_fontsampMAIN.pas' {MainForm},
  Frm_fontSampABOUT in '..\FontSamp\Frm_fontSampABOUT.pas' {AboutForm},
  PREVIEW in '..\FontSamp\PREVIEW.pas' {PreviewForm},
  DRAWPAGE in '..\FontSamp\DRAWPAGE.pas';

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

