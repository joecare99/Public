program Aboutex;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFnDEF FPC}
  {$ELSE}
  Interfaces,
  {$ENDIF }
  Forms,
  Frm_ABOUT in '..\source\ABOUTEX\frm_About.PAS' {frmAbout},
  Frm_AboutExMAIN in '..\source\ABOUTEX\Frm_AboutExMAIN.PAS' {frmAboutMain};

{$E EXE}
{$R *.res}

begin
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;

end.
