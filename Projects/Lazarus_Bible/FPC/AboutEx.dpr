program AboutEx;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  DefaultTranslator,
{$ifdef linux}
   Frm_AboutExMAIN in '..\source\AboutEx\Frm_AboutExMAIN.pas',
{$else}
  Frm_AboutExMAIN in '..\source\AboutEx\Frm_AboutExMAIN.pas',
{$endif}
Frm_ABOUT in '..\source\AboutEx\Frm_ABOUT.pas';

{$IFnDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
