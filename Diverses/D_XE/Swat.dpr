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
  frm_SwatMain in '..\Source\D7Demos\Swat\frm_SwatMain.pas' {frmSwatMain},
  frm_AboutSwat in '..\Source\D7Demos\Swat\frm_AboutSwat.pas' {frmAboutSwat},
  frm_SwatOptions in '..\Source\D7Demos\Swat\frm_SwatOptions.pas' {frmSwatOptionDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Swat: Catch the flies';
  Application.CreateForm(TfrmSwatMain, frmSwatMain);
  Application.CreateForm(TfrmAboutSwat, frmAboutSwat);
  Application.CreateForm(TfrmSwatOptionDlg, frmSwatOptionDlg);
  Application.Run;
end.
