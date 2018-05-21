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
  Frm_YesNoMAIN in '..\Source\YESNO\Frm_YesNoMAIN.PAS' {MainForm}, 
  Frm_YesNo in '..\Source\YESNO\YESNO.PAS' {YesNoDlg};
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
