program YesNoTest;
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
uses 
  {$IFnDEF FPC}
  {$ELSE}
    Interfaces,
  {$ENDIF}
  Forms,
  Frm_YesNoMAIN in '..\source\YESNO\Frm_YesNoMAIN.pas' {MainForm}, 
  Frm_YesNo in '..\source\YESNO\Frm_YesNo.pas' {YesNoDlg};
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
  Application.Initialize; 
  Application.title:='Demo: YesNoTest';
  Application.CreateForm(TfrmYesNoMain, frmYesNoMain);
  Application.CreateForm(TfrmYesNoDlg, frmYesNoDlg);
  Application.Run; 
end. 
