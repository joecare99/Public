program FontSamp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_fontsampMAIN in '..\Source\FONTSAMP\frm_fontsampMAIN.PAS' {MainForm}, 
  Frm_fontSampABOUT in '..\Source\FONTSAMP\Frm_fontSampABOUT.PAS' {AboutForm}, 
  PREVIEW in '..\Source\FONTSAMP\PREVIEW.PAS' {PreviewForm}, 
  DRAWPAGE in '..\Source\FONTSAMP\DRAWPAGE.PAS';
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
Application.Initialize; 
  Application.Title := 'Demo: Fontsamp'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.CreateForm(TPreviewForm, PreviewForm); 
  Application.Run; 
end. 
