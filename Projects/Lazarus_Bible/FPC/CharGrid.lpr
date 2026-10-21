program CharGrid;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  SysUtils,
  FormShot,
  Frm_CharGridABOUT,
  Frm_CharGridMAIN;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.Title := 'Demo: Chargrid';
  Application.CreateForm(TfrmCharGridMain, frmCharGridMain);
  Application.CreateForm(TfrmAboutForm, frmAboutForm);
  if (ParamCount > 1) and (ParamStr(1) = '--screenshot') then
  begin
    frmCharGridMain.Show;
    Application.ProcessMessages;
    SaveFormToImage(frmCharGridMain, ChangeFileExt(ParamStr(2), '.bmp'));
    Application.Terminate;
  end;
  Application.Run;
end.
