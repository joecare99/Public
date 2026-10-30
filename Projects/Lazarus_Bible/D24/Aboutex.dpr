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
  Frm_ABOUT in '..\source\AboutEx\Frm_ABOUT.pas' {frmAbout},
  Frm_AboutExMAIN in '..\source\AboutEx\Frm_AboutExMAIN.pas' {frmAboutMain};

{$E EXE}
{$R *.res}

begin
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TfrmAboutMain, frmAboutMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;

end.
