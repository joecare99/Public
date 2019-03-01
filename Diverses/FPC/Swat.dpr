program Swat;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_SwatMain {SwatForm},
  frm_AboutSwat {AboutBox},
  frm_SwatOptions {OptionsDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Swat: Catch the flies';
  Application.CreateForm(TfrmSwatMain, frmSwatMain);
  Application.CreateForm(TfrmAboutSwat, frmAboutSwat);
  Application.CreateForm(TfrmSwatOptionDlg, frmSwatOptionDlg);
  Application.Run;
end.
