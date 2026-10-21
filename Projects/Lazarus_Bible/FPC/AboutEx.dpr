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
   Frm_AboutExMAIN in '../source/ABOUTEX/frm_AboutExMain.pas',
{$else}
  Frm_AboutExMAIN in '..\source\ABOUTEX\frm_AboutExMain.pas',
{$endif}
frm_about in '..\source\ABOUTEX\frm_About.pas';

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
